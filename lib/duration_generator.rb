#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'

class DurationGenerator
  def initialize
    @critics = []

    duration_critic_order = 3
    @duration_critic = DurationCritic.new(duration_critic_order)
    @critics.push @duration_critic
  end

  def get_critics
    return @critics
  end

  def reset
    @critics.each { |x| x.reset }
  end

  def generate
    expectations = RandomVariable.new(Duration.num_values)
    
    duration_exp = @duration_critic.get_expectations
    expectations += duration_exp if !duration_exp.nil?

    return Duration.new(expectations.choose_outcome)
  end
end
