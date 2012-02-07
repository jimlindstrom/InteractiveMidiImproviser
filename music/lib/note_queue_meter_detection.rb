#!/usr/bin/env ruby

# assumes it is included in NoteQueue
module CanDetectMeter
  attr_accessor :tempo, :meter

  def detect_meter
    bsm = Music::BeatSimilarityMatrix.new(self.beat_array)
    bsm_diags = (1..20).map{ |i| { :subbeat=>i, :score=>bsm.geometric_mean_of_diag(i) } }.sort{ |x,y| y[:score] <=> x[:score] }
    $log.info "\t\tbsm_diags: #{bsm_diags.inspect.gsub(/, {/, "\n\t\t            {")}" if $log

    return false if !detect_meter_period(bsm, bsm_diags)
    return false if (initial_beat_position = detect_initial_beat_position(bsm)).nil?

    set_beat_position_of_all_notes(initial_beat_position)

    return true
  end

private

  def detect_meter_period(bsm, bsm_diags)
    confidence = bsm_diags[0][:score].to_f / bsm_diags[1][:score]
    if confidence < 2.0
      $log.info "\t\tpeak-to-next-peak ratio (#{confidence}) is too low" if $log
      #return false
    end

    # note: this assumes that the meter can only be 2/4, 3/4 or 4/4
    case subbeats_per_measure = bsm_diags[0][:subbeat] 
      when 2
        subbeats_per_beat = 1 # 2/4 (quarter note beats)
        beats_per_measure = subbeats_per_measure/subbeats_per_beat
      when 3
        subbeats_per_beat = 1 # 3/4(quarter note beats)
        beats_per_measure = subbeats_per_measure/subbeats_per_beat
      when 4
        if bsm.geometric_mean_of_diag(8) > 0.1*bsm.geometric_mean_of_diag(4)
          subbeats_per_beat = 2 # 4/4 (eighth note beats)
          beats_per_measure = 4
        elsif bsm.geometric_mean_of_diag(16) > 0.05*bsm.geometric_mean_of_diag(4)
          subbeats_per_beat = 4 # 4/4 (eighth note beats)
          beats_per_measure = 4
        else
          subbeats_per_beat = 1 # 4/4 (quarter note beats)
          beats_per_measure = 4
        end
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
        if bsm.geometric_mean_of_diag(8) > 0.05*bsm.geometric_mean_of_diag(16)
          subbeats_per_beat = 2 # 4/4 (eighths; two measure phrases)
          beats_per_measure = 4
        else
          subbeats_per_beat = 4 # 4/4 (sixteenths)
          beats_per_measure = 4
        end
      else
        $log.warn "\t\tunexpected subbeats_per_measure: #{bsm_diags[0][:beat]}" if $log
        return false
    end

    beat_unit = 4
    $log.info "\t\tMeter.new(#{beats_per_measure}, #{beat_unit}, #{subbeats_per_beat})" if $log
    begin
      @meter = Music::Meter.new(beats_per_measure, beat_unit, subbeats_per_beat)
    rescue ArgumentError
      $log.warn "\t\tFailed to instantiate meter" if $log
      return false # if any of the params were bogus, just return and fail
    end

    return true
  end
 
  def detect_initial_beat_position(bsm)
    $log.info "\ttrying to detect initial beat position:" if $log

    correl_len = @meter.subbeats_per_measure
    ba = self.beat_array
    correls = [0.0]*correl_len
    (0..(ba.length-1)).each do |i|
      if !(cur_beat = ba[i]).nil?
        if (cur_note = cur_beat.cur_note).class == Music::Note
          correls[correl_len - 1 - ((correl_len -1 + i) % correl_len)] += cur_note.duration.val
        end
      end
    end
    correls = (0..(correls.length-1)).collect { |i| { :subbeat=>i, :score=>correls[i] } }.sort{ |x,y| y[:score]<=>x[:score] }
    $log.info "\t\tcorrels: #{correls.inspect.gsub(/, {/, "\n\t\t          {")}" if $log

    initial_subbeat = correls[0][:subbeat]
    confidence = correls[0][:score].to_f / correls[1][:score]

    if confidence < 1.5
      $log.info "\t\tConfidence (#{confidence}) about starting subbeat (#{initial_subbeat}) is too low" if $log
      initial_subbeat = 0
    end

    b = Music::BeatPosition.new
    b.measure           = 0
    b.beats_per_measure = @meter.beats_per_measure
    b.subbeats_per_beat = @meter.subbeats_per_beat
    b.beat              = initial_subbeat / @meter.subbeats_per_beat
    b.subbeat           = initial_subbeat % @meter.subbeats_per_beat
    $log.info "\t\tinitial beat pos: #{b.inspect}" if $log

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

