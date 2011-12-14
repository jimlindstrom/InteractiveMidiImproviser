#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'

class Critic
  def initialize
    raise NotImplementedError.new("Abstract base class - cannot be instantiated")
  end

  def reset
    raise NotImplementedError.new("Abstract base class - cannot be instantiated")
  end

  def listen(note)
    raise NotImplementedError.new("Abstract base class - cannot be instantiated")
  end

  def get_expectations
    raise NotImplementedError.new("Abstract base class - cannot be instantiated")
  end
end
