#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'

class Note
  attr_accessor :pitch, :duration

  def initialize(pitch, duration)
    @pitch = pitch 
    @duration = duration
  end

end
