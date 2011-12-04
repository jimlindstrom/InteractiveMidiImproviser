#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'

class Meter
  attr_accessor :beats_per_measure, :beat_unit, :subdivs_per_beat

  def initialize(beats_per_measure, beat_unit, subdivs_per_beat)
    raise ArgumentError.new("beats_per_measure must be in 2..12") if beats_per_measure < 2 or beats_per_measure > 12
    raise ArgumentError.new("beat_unit must be in [2, 4, 8]") if [2, 4, 8].index(beat_unit).nil?
    raise ArgumentError.new("subdivs_per_beat must be in [1, 2, 4]") if [1, 2, 4].index(subdivs_per_beat).nil?

    @beats_per_measure = beats_per_measure
    @beat_unit         = beat_unit
    @subdivs_per_beat  = subdivs_per_beat
  end

  def self.random
    beats_per_measure = Array(2..12)[(rand*10.0).round]
    beat_unit         = [2, 4, 8][(rand*2.0).round]
    subdivs_per_beat  = [1, 2, 4][(rand*2.0).round]
    return Meter.new(beats_per_measure, beat_unit, subdivs_per_beat)
  end

  def self.num_values
    return Array(2..12).length * [2, 4, 8].length * [1, 2, 4].length
  end

  def initial_beat_position
    b = BeatPosition.new
    b.measure = 0
    b.beat = 0
    b.beats_per_measure = @beats_per_measure
    b.subbeat = 0
    b.subbeats_per_beat = @subdivs_per_beat
    return b
  end

  def to_symbol
    v  = Array(2..12).index(@beats_per_measure) 
    v *= Array(2..12).length
    v += [2, 4, 8].index(@beat_unit)
    v *= [2, 4, 8].length
    v += [1, 2, 4].index(@subdivs_per_beat)
    return MeterSymbol.new(v)
  end

  def val
    { :beats_per_measure => @beats_per_measure, :beat_unit => @beat_unit, :subdivs_per_beat => @subdivs_per_beat }
  end

end
