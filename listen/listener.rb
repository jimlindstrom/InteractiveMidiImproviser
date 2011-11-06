#!/usr/bin/env ruby

require 'observer'
require 'thread'
require 'listen/machine'
require 'listen/critics/pitch_critic'
require 'listen/critics/ioi_critic'
require 'listen/critics/pitch_count_critic'
require 'listen/critics/tempo_critic'

module Listen

  class Listener
    include Observable

    attr_accessor :machine
    
    def initialize
      @pitch_critic       = Listen::Critics::PitchCritic.new
      @pitch_count_critic = Listen::Critics::PitchCountCritic.new
      @ioi_critic         = Listen::Critics::IOICritic.new
      @tempo_critic       = Listen::Critics::TempoCritic.new
    end
  
    def respond(event_queue)
      make_observation(event_queue)
      response = generate_response

      changed
      notify_observers(response)
    end

  private
  
    def make_observation(event_queue)
      @pitch_critic.observe(event_queue)
      @ioi_critic.observe(event_queue)
      @pitch_count_critic.observe(event_queue)
      @tempo_critic.observe(event_queue)
    end

    MIDI_NOTE_ON  = 144
    MIDI_NOTE_OFF = 128
    MIDI_VELOCITY_MED = 100

    def generate_response
      num_notes = @pitch_count_critic.generate[:choice]
      tempo     = @tempo_critic.generate[:choice]

      event_queue = Midi::EventQueue.new
      timestamp = 0
      num_notes.times do

        pitch_resp = @pitch_critic.generate_next_event(event_queue)
        ioi_resp   = @ioi_critic.generate_next_event(event_queue)
        if pitch_resp.nil?
          puts "got nil next pitch" # I think this happens because of states that have only been observed as terminals
        elsif ioi_resp.nil?
          puts "got nil next ioi" # I think this happens because of states that have only been observed as terminals
        else
          cur_velocity = MIDI_VELOCITY_MED
          cur_note     = pitch_resp[:next_state]
          cur_ioi      = ioi_resp[:next_state]

          event_queue.enqueue( { :message => [ MIDI_NOTE_ON, cur_note, cur_velocity ],
                                 :timestamp => timestamp } )
          timestamp += (5*tempo) * cur_ioi # not sure why this has to be *5'ed
          event_queue.enqueue( { :message => [ MIDI_NOTE_OFF, cur_note, cur_velocity ],
                                 :timestamp => timestamp } )
        end

      end

      puts "response pitches: " + event_queue.get_pitches.inspect
      iois = event_queue.get_interonset_intervals
      iois.quantize!
      puts "response IOIs: " + iois.inspect
      return event_queue
    end

  end

end
