#!/usr/bin/env ruby

require 'observer'
require 'thread'
require 'listen/machine'
require 'listen/critics/pitch_critic'

module Listen

  class Listener
    include Observable

    attr_accessor :machine
    
    def initialize
      @device_layer = nil
      @pitch_critic = Listen::Critics::PitchCritic.new
      @pitch_count = []
    end
  
    def set_device_layer(device_layer)
      @device_layer = device_layer
    end
  
    def respond(event_queue)
      make_observation(event_queue)
      response = generate_response

      changed
      notify_observers(@tempo, response)
    end

  private
  
    def make_observation(event_queue)
      # observe pitches
      observation_response = @pitch_critic.make_observation(event_queue)

      # observe pitch count
      @pitch_count.push(event_queue.get_pitches.count)

      # FIXME refactor this into an @ioi_critic
      iois = event_queue.get_interonset_intervals
      puts "\t IOIs: " + iois.inspect
      q_ret = iois.quantize!
      puts "\tqIOIs: " + iois.inspect
      @tempo = q_ret[:q] / 1000.0
      puts "\tTempo: #{@tempo}"
    end
  
    def generate_response
      response_event_queue = Midi::EventQueue.new
      num_notes=5
      num_notes.times do
        # FIXME: pitch critic shouldn't be generating note-on/note-off.  
        # need to rethink the translation layer a bit more.
        resp = @pitch_critic.generate_next_event(response_event_queue)
        if resp.nil?
          puts "got nil next_event"
        else
          response_event_queue.enqueue({:message=>[144,resp[:next_state],100],:timestamp=>0})
        end
      end

      puts "response: " + response_event_queue.get_pitches.inspect
      return response_event_queue
    end

  end

  class MachineObserver
  
    def initialize(machine, listener)
      @machine  = machine
      @listener = listener
  
      @machine.context.add_observer(self)
    end
  
    def update(event_queue)
      Thread.new do
        @listener.respond(event_queue)
        @machine.response_done
      end
    end
  
  end

  class MidiEventRouter
    def initialize(dev_layer, machine)
      dev_layer.add_observer(self)
      @machine = machine
    end
  
    def update(event)
      @machine.midievent(event)
    end
  end

  class ListenerObserver
  
    def initialize(listener, device_layer)
      @device_layer = device_layer

      listener.add_observer(self)
    end
  
    def update(tempo, response_event_queue)
      response_event_queue.each do |cur_event|
        cur_note=cur_event[:message][1]
        @device_layer.write([144, cur_note, 100])

        puts "sleeping for #{tempo} sec"
        sleep tempo*5.0

        @device_layer.write([128, cur_note, 100])
      end

      puts "done."
      puts
    end

  end

end
