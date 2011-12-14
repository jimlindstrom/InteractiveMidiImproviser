#!/usr/bin/env ruby

module Midi

  class EventQueue < Array
    def clear
      while !empty?
        a=pop
      end
    end

    def enqueue(e)
      raise ArgumentError, "Midi::EventQueue only accepts Midi::Event items" if e.class != Midi::Event
      push(e)
    end

    def to_note_queue
      iois = Midi::IOIArray.new( get_interonset_intervals + [ get_last_duration ] )
      q_ret = iois.quantize!

      notes = NoteQueue.new
      notes.tempo = q_ret[:q]
      iois.zip(get_pitches).each do |ioi, pitch|
        notes.push Note.new(Pitch.new(pitch), Duration.new(ioi))
      end
      
      return notes
    end

  protected 

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
  end

end

