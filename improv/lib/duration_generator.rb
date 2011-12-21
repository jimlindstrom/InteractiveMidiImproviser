#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'

class DurationGenerator
  def initialize
    @critics = []

    duration_critic_order = 3
    @duration_critic = DurationCritic.new(duration_critic_order)
    @critics.push @duration_critic

    duration_critic_order = 2
    duration_critic_lookahead = 3
    @duration_and_beat_position_critic = DurationAndBeatPositionCritic.new(duration_critic_order, duration_critic_lookahead)
    @critics.push @duration_and_beat_position_critic
  end

  def get_critics
    return @critics
  end

  def reset
    @critics.each { |x| x.reset }
  end

  def generate
    expectations = Math::RandomVariable.new(Music::Duration.num_values)

    # try generating with knowledge of the beat position
    duration_and_beat_position_exp = @duration_and_beat_position_critic.get_expectations
    expectations += duration_and_beat_position_exp if !duration_and_beat_position_exp.nil?

    x = expectations.choose_outcome
    return Music::Duration.new(x) if !x.nil?

    # and try adding duration stats to it
    duration_exp = @duration_critic.get_expectations
    expectations += duration_exp if !duration_exp.nil?

    x = expectations.choose_outcome
    return Music::Duration.new(x) if !x.nil?

    reset # we hit a space where we have no data.  reset and try a fallback plan

    duration_exp = @duration_critic.get_expectations
    x = duration_exp.choose_outcome
    return Music::Duration.new(x) if !x.nil?

    raise RuntimeError.new("Failed to generate a duration")
  end

end
