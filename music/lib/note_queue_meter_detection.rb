#!/usr/bin/env ruby

# assumes it is included in NoteQueue
module CanDetectMeter
  LOGGING = false

  attr_accessor :tempo, :meter

  def beat_array
    beats = []
    prev = nil
    self.each do |note|
      b = Music::Beat.new
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
    confidences = []

    bsm = Music::BeatSimilarityMatrix.new(self.beat_array)
    bsm_diags = (1..20).map{ |i| { :beat=>i, :score=>bsm.mean_of_diag(i) } }.sort{ |x,y| y[:score] <=> x[:score] }
    confidences[0] = Float(bsm_diags[0][:score]) / bsm_diags[1][:score]

    return false if bsm_diags[1][:beat] % bsm_diags[0][:beat] != 0 # abort if not an integer number of beats per measure

    subbeats_per_beat = bsm_diags[0][:beat]
    beats_per_measure = bsm_diags[1][:beat] / subbeats_per_beat
    beat_unit         = 4
    puts "bsm_diags: #{bsm_diags.inspect}" if LOGGING
    puts "Meter.new(#{beats_per_measure}, #{beat_unit}, #{subbeats_per_beat})" if LOGGING
    begin
      @meter = Music::Meter.new(beats_per_measure, beat_unit, subbeats_per_beat)
    rescue ArgumentError
      return false # if any of the params were bogus, just return and fail
    end

    correls = bsm.autocorrel_of_main_diag(bsm_diags[1][:beat])
    correls = (0..(correls.length-1)).collect { |i| { :offset=>i, :score=>correls[i] } }.sort{ |x,y| y[:score]<=>x[:score] }
    confidences[1] = Float(correls[0][:score]) / correls[1][:score]

    b = Music::BeatPosition.new
    b.measure           = 0
    b.beats_per_measure = beats_per_measure
    b.subbeats_per_beat = subbeats_per_beat
    b.beat              = Float(correls[0][:offset] / subbeats_per_beat).floor
    b.subbeat           = correls[0][:offset] % subbeats_per_beat

    set_beat_position_of_all_notes(b)

    confidence = confidences.inject(:*)
    confidence = 0.0 if (confidence.infinite? != nil)
    is_confident = (confidence > 1.5)
    puts "#{confidences.inspect} -> #{confidence.inspect} -> #{is_confident.inspect}" if LOGGING
    return is_confident
  end

private
 
  def set_beat_position_of_all_notes(first_beat_pos)
    beat_pos = first_beat_pos
    self.each do |n|
      n.analysis[:beat_position] = beat_pos.dup

      beat_pos.subbeat += n.duration.val
      while beat_pos.subbeat >= beat_pos.subbeats_per_beat
        beat_pos.beat   += 1
        beat_pos.subbeat -= beat_pos.subbeats_per_beat
      end
      while beat_pos.beat >= beat_pos.beats_per_measure
        beat_pos.measure += 1
        beat_pos.beat    -= beat_pos.beats_per_measure
      end
    end
  end

end
