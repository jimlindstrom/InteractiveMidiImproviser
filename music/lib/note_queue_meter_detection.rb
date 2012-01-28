#!/usr/bin/env ruby

# assumes it is included in NoteQueue
module CanDetectMeter
  LOGGING = true #false

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
    success = false

    if success == false
      puts "\ttrying to detect meter using tactus:" if LOGGING
      success = detect_meter__assuming_tactus_pulse_is_dominant
      puts "\t\tfailed."    if !success and LOGGING
      puts "\t\tsucceeded." if  success and LOGGING
    end

    if success == false
      puts "\ttrying to detect meter using meter pulse:" if LOGGING
      success = detect_meter__assuming_meter_pulse_is_dominant
      puts "\t\tfailed."    if !success and LOGGING
      puts "\t\tsucceeded." if  success and LOGGING
    end

    return success
  end

private

  def detect_meter__assuming_meter_pulse_is_dominant
    confidences = []

    bsm = Music::BeatSimilarityMatrix.new(self.beat_array)
    bsm_diags = (1..20).map{ |i| { :beat=>i, :score=>bsm.geometric_mean_of_diag(i) } }.sort{ |x,y| y[:score] <=> x[:score] }

    confidence = bsm_diags[0][:score].to_f / bsm_diags[1][:score]
    if confidence < 2.0
      puts "\t\tpeak-to-next-peak ratio (#{confidence}) is too low" if LOGGING
      return false
    end

    case bsm_diags[0][:beat] # FIXME: this assumes that the meter can only be 2/4, 3/4 or 4/4
      when 2
        beats_per_measure = 2
        subbeats_per_beat = 1
      when 3
        beats_per_measure = 3
        subbeats_per_beat = 1
      when 4
        beats_per_measure = 4
        subbeats_per_beat = 1
      when 6
        beats_per_measure = 3
        subbeats_per_beat = 2
      when 8
        beats_per_measure = 4
        subbeats_per_beat = 2
      when 12
        if bsm.geometric_mean_of_diag(3) > bsm.geometric_mean_of_diag(4)
          beats_per_measure = 4
          subbeats_per_beat = 3
        else
          beats_per_measure = 3
          subbeats_per_beat = 4
        end
      when 16
        beats_per_measure = 4
        subbeats_per_beat = 4
      else
        puts "\t\tunexpected subbeats_per_measure: #{bsm_diags[0][:beat]}" if LOGGING
        return false
    end
    subbeats_per_measure = beats_per_measure * subbeats_per_beat

    beat_unit = 4
    puts "\t\tbsm_diags: #{bsm_diags.inspect.gsub(/, {/, "\n\t\t            {")}" if LOGGING
    puts "\t\tMeter.new(#{beats_per_measure}, #{beat_unit}, #{subbeats_per_beat})" if LOGGING
    begin
      @meter = Music::Meter.new(beats_per_measure, beat_unit, subbeats_per_beat)
    rescue ArgumentError
      puts "\t\tFailed to instantiate meter" if LOGGING
      return false # if any of the params were bogus, just return and fail
    end

    correls = bsm.autocorrel_of_main_diag(subbeats_per_measure)
    correls = (0..(correls.length-1)).collect { |i| { :offset=>i, :score=>correls[i] } }.sort{ |x,y| y[:score]<=>x[:score] }
    confidence = correls[0][:score].to_f / correls[1][:score]
    puts "\t\tcorrels: #{correls.inspect.gsub(/, {/, "\n\t\t          {")}" if LOGGING
    if confidence < 1.5
      puts "\t\tConfidence (#{confidence}) about starting subbeat (#{correls[0][:offset]}) is too low" if LOGGING
      return false
    end

    b = Music::BeatPosition.new
    b.measure           = 0
    b.beats_per_measure = beats_per_measure
    b.subbeats_per_beat = subbeats_per_beat
    b.beat              = Float(correls[0][:offset] / subbeats_per_beat).floor
    b.subbeat           = correls[0][:offset] % subbeats_per_beat

    set_beat_position_of_all_notes(b)

    return true
  end

  def detect_meter__assuming_tactus_pulse_is_dominant
    confidences = []

    bsm = Music::BeatSimilarityMatrix.new(self.beat_array)
    bsm_diags = (1..20).map{ |i| { :beat=>i, :score=>bsm.geometric_mean_of_diag(i) } }.sort{ |x,y| y[:score] <=> x[:score] }
    confidences[0] = Float(bsm_diags[0][:score]) / bsm_diags[1][:score]

    return false if bsm_diags[1][:beat] % bsm_diags[0][:beat] != 0 # abort if not an integer number of beats per measure

    subbeats_per_beat    = bsm_diags[0][:beat]
    subbeats_per_measure = bsm_diags[1][:beat] 
    beats_per_measure    = subbeats_per_measure / subbeats_per_beat
    beat_unit            = 4
    puts "\t\tbsm_diags: #{bsm_diags.inspect.gsub(/, {/, "\n\t\t            {")}" if LOGGING
    puts "\t\tMeter.new(#{beats_per_measure}, #{beat_unit}, #{subbeats_per_beat})" if LOGGING
    begin
      @meter = Music::Meter.new(beats_per_measure, beat_unit, subbeats_per_beat)
    rescue ArgumentError
      puts "\t\tFailed to instantiate meter" if LOGGING
      return false # if any of the params were bogus, just return and fail
    end

    correls = bsm.autocorrel_of_main_diag(subbeats_per_measure)
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
    puts "\t\t#{confidences.inspect} -> #{confidence.inspect} -> #{is_confident.inspect}" if LOGGING
    return is_confident
  end
 
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

