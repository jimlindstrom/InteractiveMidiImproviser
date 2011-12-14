#!/usr/bin/env ruby

module Music
  
  class Note
    attr_accessor :pitch, :duration, :analysis
  
    def initialize(pitch, duration)
      @pitch = pitch 
      @duration = duration
      @analysis = {}
    end
  
  end

end
