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
    bsm_diags = (1..20).map{ |i| { :beat=>i, :score=>bsm.mean_of_diag(i) } }.sort{ |x,y| y[:score] <=> x[:score] }

    subdivs_per_beat  = bsm_diags[0][:beat]
    beats_per_measure = bsm_diags[1][:beat] / subdivs_per_beat
    beat_unit         = 4
    @meter = Meter.new(beats_per_measure, beat_unit, subdivs_per_beat)

    correls = bsm.autocorrel_of_main_diag(bsm_diags[1][:beat])
    correls = (0..(correls.length-1)).collect { |i| { :offset=>i, :score=>correls[i] } }.sort{ |x,y| y[:score]<=>x[:score] }
    #@meter[:offset]      = correls[0][:offset]
  end

end
