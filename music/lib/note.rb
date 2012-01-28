#!/usr/bin/env ruby

module Music
  
  class Note < Event
    attr_accessor :pitch
  
    def initialize(pitch, duration)
      super(duration)
      @pitch = pitch 
    end
  
  end

end
