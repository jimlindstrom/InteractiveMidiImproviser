#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'

class MeterSymbol
  def initialize(new_val)
    set_val(new_val)
  end

  def set_val(new_val)
    raise ArgumentError.new("value cannot be negative") if new_val < 0
    raise ArgumentError.new("value cannot be > 98") if new_val > 98

    @val = new_val
  end

  def val
    return @val
  end

  def to_meter
    v = @val

    subdivs_per_beat = [1, 2, 4][v % [1, 2, 4].length]
    v = Float(v / [1, 2, 4].length).floor

    beat_unit = [2, 4, 8][v % [2, 4, 8].length]
    v = Float(v / [2, 4, 8].length).floor

    beats_per_measure = Array(2..12)[v % Array(2..12).length]

    return Meter.new(beats_per_measure, beat_unit, subdivs_per_beat)
  end
end
