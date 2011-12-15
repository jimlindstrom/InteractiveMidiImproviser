#!/usr/bin/env ruby

module Music
  
  class Meter
    def to_symbol
      v  = Array(2..6).index(@beats_per_measure) 
      v *= Array(2..6).length
      v += [2, 4, 8].index(@beat_unit)
      v *= [2, 4, 8].length
      v += [1, 2, 4].index(@subdivs_per_beat)
      return MeterSymbol.new(v)
    end
  end

end

