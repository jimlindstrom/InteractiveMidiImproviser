#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'

class Sensor
  def initialize
    raise RuntimeError.new("Cannot instantiate abstract base class.")
  end

  def get_stimulus
    raise RuntimeError.new("Cannot instantiate abstract base class.")
  end
end
