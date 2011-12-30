#!/usr/bin/env ruby

class PitchGenerator
  def initialize
    @critics = []

    @pitch_critic = PitchCritic.new(pitch_critic_order=2)
    @critics.push @pitch_critic

    @interval_critic = IntervalCritic.new(interval_critic_order=3, 
                                          interval_critic_lookahead=3)
    @critics.push @interval_critic

    @pitch_and_pitch_class_set_critic = PitchAndPitchClassSetCritic.new(pitch_and_pitch_class_set_critic_order=6,
                                                                        pitch_and_pitch_class_set_critic_lookahead=3)
    @critics.push @pitch_and_pitch_class_set_critic


    @complex_pitch_critic = ComplexPitchCritic.new(@pitch_critic,
                                                   @interval_critic,
                                                   @pitch_and_pitch_class_set_critic)
    @critics.push @complex_pitch_critic # FIXME: order-dependent.  Assumes the 1st 3 will be listen()'ed first
  end

  def get_critics
    return @critics
  end

  def reset
    @critics.each { |x| x.reset }
  end

  def generate
    expectations = @complex_pitch_critic.get_expectations
    x = expectations.choose_outcome
    return Music::Pitch.new(x) if !x.nil?

    raise RuntimeError.new("Failed to choose a pitch")
  end
end
