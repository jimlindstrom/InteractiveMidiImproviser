#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'

class NoteQueue < Array
  attr_accessor :tempo

  def to_event_queue
    raise ArgumentError.new("tempo must be set") if @tempo.nil? 

    eq = Midi::EventQueue.new
    timestamp = 0
    self.each do |note|
      eq.enqueue Midi::Event.new({:message   => Midi::Event::NOTE_ON,
                                  :pitch     => note.pitch.val,
                                  :velocity  => 100,
                                  :timestamp => timestamp })

      timestamp += note.duration.val * @tempo
      eq.enqueue Midi::Event.new({:message   => Midi::Event::NOTE_OFF,
                                  :pitch     => note.pitch.val,
                                  :velocity  => 100,
                                  :timestamp => timestamp })

    end 

    return eq
  end

end
