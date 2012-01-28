#!/usr/bin/env ruby

module Music
  
  class Event
    attr_accessor :duration, :analysis
  
    def initialize(duration)
      @duration = duration
      @analysis = {}
    end
  
  end

end
