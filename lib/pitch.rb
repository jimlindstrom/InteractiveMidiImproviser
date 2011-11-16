#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'

class Pitch
  def initialize(new_val)
    set_val(new_val)
  end

  def self.num_values
    128
  end

  def set_val(new_val)
    raise ArgumentError.new("value (#{new_val}) cannot be negative") if new_val < 0
    raise ArgumentError.new("value (#{new_val}) cannot be > 127") if new_val > 127

    @val = new_val
  end

  def val
    return @val
  end

  def to_symbol
    return PitchSymbol.new(@val)
  end
end
