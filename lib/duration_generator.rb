#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'

class DurationGenerator
  def initialize
    @critics = []

    duration_critic_order = 3
    @duration_critic = DurationCritic.new(duration_critic_order)
    @critics.push @duration_critic

    duration_critic_order = 1
    @duration_and_beat_position_critic = DurationAndBeatPositionCritic.new(duration_critic_order)
    @critics.push @duration_and_beat_position_critic
  end

  def get_critics
    return @critics
  end

  def reset
    @critics.each { |x| x.reset }
  end

  def generate
    # try generating with knowledge of the beat position
    duration_and_beat_position_exp = @duration_and_beat_position_critic.get_expectations
    if !duration_and_beat_position_exp.nil?
      x = duration_and_beat_position_exp.choose_outcome
      puts "x: #{x.inspect}"
      return DurationAndBeatPosition.new(x).duration
    end

    # if that doens't work, initialize a random variable, ...
    expectations = RandomVariable.new(Duration.num_values)

    # and try adding duration stats to it
    duration_exp = @duration_critic.get_expectations
    expectations += duration_exp if !duration_exp.nil?

    return Duration.new(expectations.choose_outcome)
  end
end
