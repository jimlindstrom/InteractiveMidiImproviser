#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'

class Interval
  def initialize(new_val)
    set_val(new_val)
  end

  def self.num_values
    return 255
  end

  def set_val(new_val)
    raise ArgumentError.new("value (#{new_val}) cannot be < -127") if new_val < -127
    raise ArgumentError.new("value (#{new_val}) cannot be > 127") if new_val > 127

    @val = new_val
  end

  def self.calculate(p1, p2)
    return Interval.new(p2.val - p1.val)
  end

  def val
    return @val
  end

  def to_symbol
    return IntervalSymbol.new(@val+127)
  end
end
