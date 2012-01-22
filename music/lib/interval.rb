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
      return @simplified_val if !@simplified_val.nil?

      @simplified_val = case @val
        when 9..127   then  8
        when 5..8     then  4
        when 2..4     then  2
        when 1        then  1
        when 0        then  0
        when -1       then -1
        when -4..-2   then -2
        when -8..-5   then -4
        when -127..-9 then -8
        else raise RuntimeError.new("Eek! unexpected val of #{@val}")
      end
  
      return @simplified_val 
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

