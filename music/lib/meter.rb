#!/usr/bin/env ruby

module Music
  
  class Meter
    attr_accessor :beats_per_measure, :beat_unit, :subbeats_per_beat

    ALLOWED_BEAT_UNITS        = [2, 4, 8]
    ALLOWED_BEATS_PER_MEASURE = Array(2..6)
    ALLOWED_SUBBEATS_PER_BEAT = [1, 2, 4]

    COMMON_BEAT_UNITS         = [4]
    COMMON_BEATS_PER_MEASURE  = [3, 4]
    COMMON_SUBBEATS_PER_BEAT  = [1, 2]
  
    def initialize(beats_per_measure, beat_unit, subbeats_per_beat)
      raise ArgumentError.new("invalid beats_per_measure: #{beats_per_measure}") if ALLOWED_BEATS_PER_MEASURE.index(beats_per_measure).nil?
      raise ArgumentError.new("invalid beat_unit: #{beat_unit}") if ALLOWED_BEAT_UNITS.index(beat_unit).nil?
      raise ArgumentError.new("invalid subbeats_per_beat: #{subbeats_per_beat}") if ALLOWED_SUBBEATS_PER_BEAT.index(subbeats_per_beat).nil?
  
      @beats_per_measure = beats_per_measure
      @beat_unit         = beat_unit
      @subbeats_per_beat = subbeats_per_beat
    end
  
    def self.random
      return Meter.new( COMMON_BEATS_PER_MEASURE.sample,
                        COMMON_BEAT_UNITS.sample,
                        COMMON_SUBBEATS_PER_BEAT.sample)
    end
  
    def self.num_values
      n  = ALLOWED_BEAT_UNITS.length
      n *= ALLOWED_BEATS_PER_MEASURE.length
      n *= ALLOWED_SUBBEATS_PER_BEAT.length
      return n
    end
  
    def initial_beat_position
      b = BeatPosition.new
      b.measure           = 0
      b.beat              = 0
      b.beats_per_measure = @beats_per_measure
      b.subbeat           = 0
      b.subbeats_per_beat = @subbeats_per_beat
      return b
    end
  
    def val
      { :beats_per_measure => @beats_per_measure, 
        :beat_unit         => @beat_unit, 
        :subbeats_per_beat => @subbeats_per_beat }
    end
  
  end

end

