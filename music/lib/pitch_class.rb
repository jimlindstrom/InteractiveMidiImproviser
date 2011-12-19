#!/usr/bin/env ruby

module Music
  
  class PitchClass
    attr_reader :val

    def initialize(new_val)
      raise ArgumentError if new_val < 0 or new_val > 11
      @val = new_val
    end
  
    def self.from_pitch(p)
      PitchClass.new((p.val + 3) % 12)
    end
  end

end

