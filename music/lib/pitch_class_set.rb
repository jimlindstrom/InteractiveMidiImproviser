#!/usr/bin/env ruby

module Music
  
  class PitchClassSet
    attr_reader :vals

    def initialize()
      @vals = []
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

