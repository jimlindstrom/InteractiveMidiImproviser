#!/usr/bin/env ruby

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
    expectations = Math::RandomVariable.new(Music::Pitch.num_values)
    
    pitch_exp = @pitch_critic.get_expectations
    expectations += pitch_exp if !pitch_exp.nil?

    interval_exp = @interval_critic.get_expectations
    expectations += interval_exp if !interval_exp.nil?

    x = expectations.choose_outcome
    return Music::Pitch.new(x) if !x.nil?

    reset # we got to a point where we have no data.  reset, to get back to some stat we know about

    pitch_exp = @pitch_critic.get_expectations
    x = pitch_exp.choose_outcome
    return Music::Pitch.new(x) if !x.nil?

    raise RuntimeError.new("Failed to choose a pitch")
  end
end