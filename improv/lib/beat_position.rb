#!/usr/bin/env ruby

module Music
  
  class BeatPosition
  
    def to_symbol
      validate
  
      v  = @beat
  
      v *= [0, 1, 2, 3].length
      v += [0, 1, 2, 3].index(@subbeat)
  
      v *= Array(2..12).length
      v += Array(2..12).index(@beats_per_measure)
  
      v *= [1, 2, 4].length
      v += [1, 2, 4].index(@subbeats_per_beat)
  
      return BeatPositionSymbol.new(v)
    end
  
  end
  
end
