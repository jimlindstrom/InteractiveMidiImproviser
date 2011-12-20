#!/usr/bin/env ruby

module Music
  
  class PitchClassSet
    attr_reader :vals

    def initialize()
      @vals = []
    end

    def self.num_values
      2**12
    end

    def add(pc)
      @vals = (@vals + [pc.val]).sort.uniq
    end

    def remove(pc)
      raise RuntimeError.new("#{@vals} does not include #{pc.val}") if !@vals.include?(pc.val)
      @vals = @vals - [pc.val]
    end
  
  end

end

