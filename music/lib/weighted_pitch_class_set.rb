#!/usr/bin/env ruby

module Music
  
  class WeightedPitchClassSet
    def initialize
      @weight = [0.0]*12
    end

    def add(pc, w)
      @weight[pc.val] += w
    end

    def weight(pc)
      @weight[pc.val]
    end

    def pitch_classes_above_threshold(w)
      pcs = PitchClassSet.new

      h=Hash[*(0..11).zip(@weight).flatten]
      h.keep_if{ |k,v| v>=w}
      h.map{ |k,v| pcs.add(PitchClass.new(k)) }

      return pcs
    end

    def top_n_pitch_classes(n)
      pcs = PitchClassSet.new

      a = (0..11).zip(@weight).map{ |x,y| {:pc=>x, :w=>y} }
      a.sort!{ |x,y| y[:w] <=> x[:w] }
      a[0..(n-1)].map{ |x| pcs.add(PitchClass.new(x[:pc])) }

      return pcs
    end
  end

end

