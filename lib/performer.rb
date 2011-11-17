#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'

class Performer
  def initialize
    raise RuntimeError.new("Cannot instantiate abstract base class.")
  end

  def perform
    raise RuntimeError.new("Cannot instantiate abstract base class.")
  end
end
