#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'

class Critic
  attr_reader :cumulative_surprise

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

  def reset_cumulative_surprise
    @cumulative_surprise = 0.0
  end

  def add_to_cumulative_surprise(s)
    @cumulative_surprise += s
  end
end
