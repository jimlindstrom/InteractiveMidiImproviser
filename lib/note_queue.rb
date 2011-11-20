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

  def beat_array
    beats = []
    prev = nil
    self.each do |note|
      b = Beat.new
      b.prev_note = prev
      b.cur_note = note
      beats.push b

      (note.duration.val-1).times do
        beats.push nil
      end

      prev = note
    end
    return beats
  end

  def detect_meter
    bsm = BeatSimilarityMatrix.new(self.beat_array)
    data = (1..20).map{ |i| { :beat=>i, :score=>bsm.mean_of_diag(i) } }.sort{ |x,y| y[:score] <=> x[:score] }
    @meter = {}
    @meter[:tactus]     = data[0][:beat]
    @meter[:time_sig]   = [data[1][:beat] / @meter[:tactus], 4]
    @meter[:confidence] = data[1][:score] / data[2][:score]
  end

end
