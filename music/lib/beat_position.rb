#!/usr/bin/env ruby

module Music
  
  class BeatPosition
    attr_accessor :measure, :beat, :beats_per_measure, :subbeat, :subbeats_per_beat
  
    def self.num_values
      ranges = []
      ranges.push Array(0..11).length # beat
      ranges.push [1, 2, 3, 4].length # subbeat
      ranges.push Array(2..12).length # beats_per_measure
      ranges.push [1, 2, 4].length # subbeats_per_beat
      return ranges.inject(:*)
    end
  
    def to_symbol
      validate
  
      v  = @beat
  
      v *= [0, 1, 2, 3].length
      v += [0, 1, 2, 3].index(@subbeat)
  
      v *= Array(2..12).length
      v += Array(2..12).index(@beats_per_measure)
  
      v *= [1, 2, 4].length
      v += [1, 2, 4].index(@subbeats_per_beat)
  
      return BeatPositionSymbol.new(v)
    end
  
    def +(duration)
      b = BeatPosition.new
      b.subbeats_per_beat = @subbeats_per_beat
      b.beats_per_measure = @beats_per_measure
      b.subbeat = @subbeat + duration.val
      b.beat = @beat
      b.measure = @measure
  
      while b.subbeat >= b.subbeats_per_beat
        b.beat += 1
        b.subbeat -= b.subbeats_per_beat
      end
  
      while b.beat >= b.beats_per_measure
        b.measure += 1
        b.beat -= b.beats_per_measure
      end
  
      return b
    end
  
    def to_hash
      return {:measure=>@measure, :beat=>@beat, :subbeat=>@subbeat}
    end
  
    def validate
      raise RuntimeError.new("invalid beat: #{@beat}")                           if Array(0..11).index(@beat).nil?
      raise RuntimeError.new("invalid subbeat: #{@subbeat}")                     if [0, 1, 2, 3].index(@subbeat).nil?
      raise RuntimeError.new("invalid beats_per_measure: #{@beats_per_measure}") if Array(2..12).index(@beats_per_measure).nil?
      raise RuntimeError.new("invalid subbeats_per_beat: #{@subbeats_per_beat}") if [1, 2, 4].index(@subbeats_per_beat).nil?
    end
  end
  
end
