#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'

class MarkovChain

  def initialize(order, num_states)
    raise ArgumentError.new("order must be positive") if order < 1
    raise ArgumentError.new("must have two or more states") if num_states < 2

    @order = order
    @num_states = num_states

    @observations = {}

    reset
  end

  def current_state
    return @state_history.last
  end

  def reset
    @state_history        = [ nil ]*@num_states
    @state_history_string = ["nil"]*@num_states
  end

  def observe(next_state)
    raise ArgumentError.new("state must be in 0..(num_states-1) range") if (next_state < 0) or (next_state >= @num_states)

    k = state_history_to_key
    if @observations[k].nil?
      @observations[k] = {}
    end
    if @observations[k][next_state].nil?
      @observations[k][next_state] = 0
    end
    @observations[k][next_state] += 1
  end

  def transition(next_state)
    raise ArgumentError.new("state must be in 0..(num_states-1) range") if (next_state < 0) or (next_state >= @num_states)

    @state_history.push next_state
    @state_history.shift

    @state_history_string.push String(next_state || "nil")
    @state_history_string.shift
  end

  def get_expectations
    num_outcomes = @num_states
    x = RandomVariable.new(num_outcomes)
    k = state_history_to_key
    (@observations[k] || {}).keys.each do |next_state|
      num_observations = @observations[k][next_state]
      x.add_possible_outcome(next_state, num_observations)
    end
    return x
  end

private

  def state_history_to_key
    @state_history_string.join(',')
  end

end

