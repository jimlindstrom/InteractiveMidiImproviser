#!/usr/bin/env ruby

module Music
  
  class Duration
    def to_symbol
      return DurationSymbol.new(@val)
    end
  end

end

