#!/usr/bin/env ruby

module Music
  
  class Pitch
    def to_symbol
      return PitchSymbol.new(@val)
    end
  end

end

