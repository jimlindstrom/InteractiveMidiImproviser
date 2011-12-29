#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'

class Critic
  attr_reader :cumulative_information_content

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

  def reset_cumulative_information_content
    @cumulative_information_content = 0.0
  end

  def add_to_cumulative_information_content(s)
    @cumulative_information_content += s
  end
end
