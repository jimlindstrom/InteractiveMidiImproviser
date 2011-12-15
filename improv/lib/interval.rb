#!/usr/bin/env ruby

module Music
  
  class Interval
    def to_symbol
      return IntervalSymbol.new(@val+127)
    end
  end

end

