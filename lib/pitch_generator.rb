#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'

class PitchGenerator
  def initialize
    @critics = []

    pitch_critic_order = 2
    @pitch_critic = PitchCritic.new(pitch_critic_order)
    @critics.push @pitch_critic

    interval_critic_order = 2
    @interval_critic = IntervalCritic.new(interval_critic_order)
    @critics.push @interval_critic
  end

  def get_critics
    return @critics
  end

  def reset
    @critics.each { |x| x.reset }
  end

  def generate
    expectations = RandomVariable.new(Pitch.num_values)
    
    pitch_exp = @pitch_critic.get_expectations
    expectations += pitch_exp if !pitch_exp.nil?

    interval_exp = @interval_critic.get_expectations
    expectations += interval_exp if !interval_exp.nil?

    return Pitch.new(expectations.choose_outcome)
  end
end
