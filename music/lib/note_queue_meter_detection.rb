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
    bsm = Music::BeatSimilarityMatrix.new(self.beat_array)
    bsm_diags = (1..20).map{ |i| { :subbeat=>i, :score=>bsm.geometric_mean_of_diag(i) } }.sort{ |x,y| y[:score] <=> x[:score] }
    puts "\t\tbsm_diags: #{bsm_diags.inspect.gsub(/, {/, "\n\t\t            {")}" if LOGGING

    return false if !detect_meter_period(bsm, bsm_diags)
    return false if (initial_beat_position = detect_initial_beat_position(bsm)).nil?

    set_beat_position_of_all_notes(initial_beat_position)

    return true
  end

private

  def detect_meter_period(bsm, bsm_diags)
    confidence = bsm_diags[0][:score].to_f / bsm_diags[1][:score]
    if confidence < 2.0
      puts "\t\tpeak-to-next-peak ratio (#{confidence}) is too low" if LOGGING
      #return false
    end

    case subbeats_per_measure = bsm_diags[0][:subbeat] # FIXME: this assumes that the meter can only be 2/4, 3/4 or 4/4
      when 2 .. 4
        subbeats_per_beat = 1 # 2/4, 3/4, 4/4 (quarter note beats)
        beats_per_measure = subbeats_per_measure/subbeats_per_beat
      when 6
        subbeats_per_beat = 2 # 3/4 (eighth note beats)
        beats_per_measure = subbeats_per_measure/subbeats_per_beat
      when 8
        if bsm.geometric_mean_of_diag(16) > 0.4*bsm.geometric_mean_of_diag(8)
          subbeats_per_beat = 4 # 4/4 (sixteenth note beats; strong tactus)
          beats_per_measure = 4
        else
          subbeats_per_beat = 2 # 4/4 (eighth note beats)
          beats_per_measure = subbeats_per_measure/subbeats_per_beat
        end
      when 9
        subbeats_per_beat = 3 # 3/4 (triplets)
        beats_per_measure = subbeats_per_measure/subbeats_per_beat
      when 12
        if bsm.geometric_mean_of_diag(3) > bsm.geometric_mean_of_diag(4)
          subbeats_per_beat = 3 # 4/4 (triplets)
          beats_per_measure = subbeats_per_measure/subbeats_per_beat
        else
          if bsm.geometric_mean_of_diag(6) > 0.4*bsm.geometric_mean_of_diag(12)
            subbeats_per_beat = 2 # 3/4 (eighths; two measure phrases)
            beats_per_measure = 3
          else
            subbeats_per_beat = 4 # 3/4 (sixteenths)
            beats_per_measure = subbeats_per_measure/subbeats_per_beat
          end
        end
      when 16
        if bsm.geometric_mean_of_diag(8) > 0.1*bsm.geometric_mean_of_diag(16)
          subbeats_per_beat = 2 # 4/4 (eighths; two measure phrases)
          beats_per_measure = 4
        else
          subbeats_per_beat = 4 # 4/4 (sixteenths)
          beats_per_measure = 4
        end
      else
        puts "\t\tunexpected subbeats_per_measure: #{bsm_diags[0][:beat]}" if LOGGING
        return false
    end

    beat_unit = 4
    puts "\t\tMeter.new(#{beats_per_measure}, #{beat_unit}, #{subbeats_per_beat})" if LOGGING
    begin
      @meter = Music::Meter.new(beats_per_measure, beat_unit, subbeats_per_beat)
    rescue ArgumentError
      puts "\t\tFailed to instantiate meter" if LOGGING
      return false # if any of the params were bogus, just return and fail
    end

    return true
  end
 
  def detect_initial_beat_position(bsm)
    puts "\ttrying to detect initial beat position:" if LOGGING

    correls = bsm.autocorrel_of_main_diag(@meter.beats_per_measure * @meter.subbeats_per_beat)
    correls = (0..(correls.length-1)).collect { |i| { :subbeat=>i, :score=>correls[i] } }.sort{ |x,y| y[:score]<=>x[:score] }
    puts "\t\tcorrels: #{correls.inspect.gsub(/, {/, "\n\t\t          {")}" if LOGGING

    initial_subbeat = correls[0][:subbeat]
    confidence = correls[0][:score].to_f / correls[1][:score]

    if confidence < 1.10 and correls[0][:subbeat] > 0
      puts "\t\tConfidence (#{confidence}) about starting subbeat (#{initial_subbeat}) is too low" if LOGGING
      #return nil
    end

    b = Music::BeatPosition.new
    b.measure           = 0
    b.beats_per_measure = @meter.beats_per_measure
    b.subbeats_per_beat = @meter.subbeats_per_beat
    b.beat              = initial_subbeat / @meter.subbeats_per_beat
    b.subbeat           = initial_subbeat % @meter.subbeats_per_beat
    puts "\t\tinitial beat pos: #{b.inspect}" if LOGGING

    return b
  end

  def set_beat_position_of_all_notes(initial_beat_position)
    beat_pos = initial_beat_position
    self.each do |n|
      n.analysis[:beat_position] = beat_pos.dup

      beat_pos.subbeat += n.duration.val
      while beat_pos.subbeat >= beat_pos.subbeats_per_beat
        beat_pos.beat    += 1
        beat_pos.subbeat -= beat_pos.subbeats_per_beat
      end
      while beat_pos.beat >= beat_pos.beats_per_measure
        beat_pos.measure += 1
        beat_pos.beat    -= beat_pos.beats_per_measure
      end
    end
  end

end

