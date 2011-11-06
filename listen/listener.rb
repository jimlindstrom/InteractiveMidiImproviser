#!/usr/bin/env ruby

require 'observer'
require 'thread'
require 'listen/machine'
require 'listen/critics/pitch_critic'
require 'listen/critics/pitch_count_critic'
require 'listen/critics/tempo_critic'

module Listen

  class Listener
    include Observable

    attr_accessor :machine
    
    def initialize
      @pitch_critic       = Listen::Critics::PitchCritic.new
      @pitch_count_critic = Listen::Critics::PitchCountCritic.new
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

        resp = @pitch_critic.generate_next_event(event_queue)
        if resp.nil?
          puts "got nil next_event" # I think this happens because of states that have only been observed as terminals
        else
          cur_note     = resp[:next_state]
          cur_ioi      = 1
          cur_velocity = MIDI_VELOCITY_MED

          event_queue.enqueue( { :message => [ MIDI_NOTE_ON, cur_note, cur_velocity ],
                                 :timestamp => timestamp } )
          timestamp += (5*tempo) * cur_ioi
          event_queue.enqueue( { :message => [ MIDI_NOTE_OFF, cur_note, cur_velocity ],
                                 :timestamp => timestamp } )
        end

      end

      puts "response: " + event_queue.get_pitches.inspect
      return event_queue
    end

  end

end
