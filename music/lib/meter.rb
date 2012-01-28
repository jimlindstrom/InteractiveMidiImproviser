#!/usr/bin/env ruby

module Music
  
  class Meter
    attr_accessor :beats_per_measure, :beat_unit, :subbeats_per_beat
  
    def initialize(beats_per_measure, beat_unit, subbeats_per_beat)
      raise ArgumentError.new("beats_per_measure must be in 2..6") if beats_per_measure < 2 or beats_per_measure > 6
      raise ArgumentError.new("beat_unit must be in [2, 4, 8]") if [2, 4, 8].index(beat_unit).nil?
      raise ArgumentError.new("subbeats_per_beat must be in [1, 2, 4]") if [1, 2, 4].index(subbeats_per_beat).nil?
  
      @beats_per_measure = beats_per_measure
      @beat_unit         = beat_unit
      @subbeats_per_beat = subbeats_per_beat
    end
  
    def self.random
      # this is the whole set of possibilities
      #beats_per_measure = Array(2..6).sample
      #beat_unit         = [2, 4, 8].sample
      #subbeats_per_beat = [1, 2, 4].sample
      #return Meter.new(beats_per_measure, beat_unit, subbeats_per_beat)
  
      # this is a more common, constrained set of possibilities
      beats_per_measure = [3, 4].sample
      beat_unit         = [4].sample
      subbeats_per_beat = [1, 2].sample
      return Meter.new(beats_per_measure, beat_unit, subbeats_per_beat)
    end
  
    def self.num_values
      return Array(2..6).length * [2, 4, 8].length * [1, 2, 4].length
    end
  
    def initial_beat_position
      b = BeatPosition.new
      b.measure = 0
      b.beat = 0
      b.beats_per_measure = @beats_per_measure
      b.subbeat = 0
      b.subbeats_per_beat = @subbeats_per_beat
      return b
    end
  
    def val
      { :beats_per_measure => @beats_per_measure, :beat_unit => @beat_unit, :subbeats_per_beat => @subbeats_per_beat }
    end
  
  end

end

