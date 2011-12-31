#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'

class DurationGenerator
  def initialize
    @critics = []

    @duration_critic = DurationCritic.new(duration_critic_order=3)
    @critics.push @duration_critic

    @duration_and_beat_position_critic = DurationAndBeatPositionCritic.new(duration_critic_order=2, duration_critic_lookahead=3)
    @critics.push @duration_and_beat_position_critic

    # FIXME: order dependency.  Assumes that this will get called to listen() after the prev. two critics
    @complex_duration_critic = ComplexDurationCritic.new(@duration_critic, @duration_and_beat_position_critic)
    @critics.push @complex_duration_critic
  end

  def get_critics
    return @critics
  end

  def reset
    @critics.each { |x| x.reset }
  end

  def generate
    expectations = @complex_duration_critic.get_expectations
    x = expectations.choose_outcome
    return Music::Duration.new(x) if !x.nil?

    raise RuntimeError.new("Failed to generate a duration")
  end

end
