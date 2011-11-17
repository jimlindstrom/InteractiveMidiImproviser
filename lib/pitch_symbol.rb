#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'

class PitchSymbol
  def initialize(new_val)
    set_val(new_val)
  end

  def set_val(new_val)
    raise ArgumentError.new("value cannot be negative") if new_val < 0
    raise ArgumentError.new("value cannot be > 127") if new_val > 127

    @val = new_val
  end

  def val
    return @val
  end

  def to_pitch
    return Pitch.new(@val)
  end
end
