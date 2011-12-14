#!/usr/bin/env ruby

class BeatPositionSymbol
  def initialize(new_val)
    set_val(new_val)
  end

  def set_val(new_val)
    raise ArgumentError.new("value cannot be negative") if new_val < 0
    raise ArgumentError.new("value cannot be > 1583") if new_val > 1583

    @val = new_val
  end

  def val
    return @val
  end

  def to_object
    b = BeatPosition.new

    v = @val
    b.subbeats_per_beat = [1, 2, 4][v % [1, 2, 4].length]
    v = Float(v / [1, 2, 4].length).floor

    b.beats_per_measure = Array(2..12)[v % Array(2..12).length]
    v = Float(v / Array(2..12).length).floor

    b.subbeat = [0, 1, 2, 3][v % [0, 1, 2, 3].length]
    v = Float(v / [0, 1, 2, 3].length).floor
    
    b.beat = Array(0..11)[v % Array(0..11).length]

    return b
  end
end
