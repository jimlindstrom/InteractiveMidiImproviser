#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'

class Note
  attr_accessor :pitch, :duration, :analysis

  def initialize(pitch, duration)
    @pitch = pitch 
    @duration = duration
    @analysis = {}
  end

end
