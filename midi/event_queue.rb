#!/usr/bin/env ruby

require 'midi/ioi_array'

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

    def get_pitches
      select{|x| x.message==Midi::Event::NOTE_ON }.map{|x| x.pitch }
    end

    def get_interonset_intervals
      return Midi::IOIArray.new( select{|x| x.message==Midi::Event::NOTE_ON }.map{|x| x.timestamp }.each_cons(2).map{ |a,b| b-a } )
    end
  end

end

