#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'

class NoteQueue < Array
  attr_accessor :tempo, :meter

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

  def detect_meter
    meters = []
     
    (1..8).each do |m|
      meter = { }
      meter[:time_sig]   = [4, 4]
      meter[:weights]    = [4, 1, 2, 1]
      meter[:multiplier] = m
      md = MeterDetector.new(meter[:time_sig], meter[:weights], meter[:multiplier])
      score = md.calculate(self.map{|x| x.duration.val})
      meter[:offset] = score[:offset]
      meter[:score]  = score[:score]

      meters.push meter
    end

    (1..8).each do |m|
      meter = { }
      meter[:time_sig]   = [3, 4]
      meter[:weights]    = [3, 1, 1]
      meter[:multiplier] = m
      md = MeterDetector.new(meter[:time_sig], meter[:weights], meter[:multiplier])
      score = md.calculate(self.map{|x| x.duration.val})
      meter[:offset] = score[:offset]
      meter[:score]  = score[:score]

      meters.push meter
    end

    meters.sort!{ |x,y| x[:score] <=> y[:score] }
    @meter = meters.last
    @meter[:confidence] = meters[-1][:score] / meters[-2][:score]
  end

end
