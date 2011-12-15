#!/usr/bin/env ruby

module Music
  
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
  
    def simplified_val
      new_val =  8 if (@val >   8)
      new_val =  4 if (@val >   4) and (@val <= 8)
      new_val =  2 if (@val >   1) and (@val <= 4)
      new_val =  1 if (@val ==  1)
      new_val =  0 if (@val ==  0)
      new_val = -1 if (@val == -1)
      new_val = -2 if (@val <  -1) and (@val >= -4)
      new_val = -4 if (@val <  -4) and (@val >= -8)
      new_val = -8 if (@val <  -8)
  
      @val = new_val
    end
  
    def similarity_to(p) # returns 1 for identical; 0 for totally different
      return 0.00 if p.nil?
      delta = Float(p.simplified_val - self.simplified_val)
      max_delta = 8.0
      diff = delta**2 / max_delta**2
      flattened_diff = diff**0.25
      clipped_diff = [ 0.0, [ 1.0, flattened_diff ].min ].max
      similarity = 1.0 - clipped_diff
      return similarity
    end
  
  end

end

