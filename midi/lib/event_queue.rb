#!/usr/bin/env ruby

module Midi

  class EventQueue < Array
    def clear
      while !empty?
        a=pop
      end
    end

    def enqueue(e)
      raise ArgumentError, "Midi::EventQueue only accepts Midi::Event items" if !e.is_a?(Midi::Event)
      push(e)
    end

    def get_pitches
      select{|x| x.message==Midi::Event::NOTE_ON }.map{|x| x.pitch }
    end

    def get_interonset_intervals
      return select{|x| x.message==Midi::Event::NOTE_ON }.map{|x| x.timestamp }.each_cons(2).map{ |a,b| b-a }
    end

    def get_last_duration
      last_note_on = select{ |x| x.message==Midi::Event::NOTE_ON}.last
      last_note_off = select{ |x| (x.message==Midi::Event::NOTE_OFF) && (x.pitch==last_note_on.pitch) }.last

      return last_note_off.timestamp - last_note_on.timestamp
    end

    def get_durations
      durations = []

      self.each_with_index do |e1, idx|
        if e1.message==Midi::Event::NOTE_ON
          e2=self[idx..-1].find{ |x| x.message==Midi::Event::NOTE_OFF and x.pitch==e1.pitch }
          durations.push e2.timestamp - e1.timestamp
        end
      end

      return durations
    end
  end

end

