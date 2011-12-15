#!/usr/bin/env ruby

module Music

  class DurationAndBeatPosition
    def to_symbol
      v  = @duration.to_symbol.val
  
      v *= BeatPosition.num_values
      v += @beat_position.to_symbol.val
  
      return DurationAndBeatPositionSymbol.new(v)
    end
  end
  
end
