#!/usr/bin/env ruby

class DurationAndBeatPositionSymbol
  def initialize(new_val)
    set_val(new_val)
  end

  def set_val(new_val)
    raise ArgumentError.new("value cannot be negative") if new_val < 0
    raise ArgumentError.new("value cannot be > 202751") if new_val > 202751

    @val = new_val
  end

  def val
    return @val
  end

  def to_object
    bps = BeatPositionSymbol.new(@val % BeatPosition.num_values)
    ds  = DurationSymbol.new((@val / BeatPosition.num_values).floor)
    dbp = DurationAndBeatPosition.new(ds.to_object, bps.to_object)
    return dbp
  end
end
