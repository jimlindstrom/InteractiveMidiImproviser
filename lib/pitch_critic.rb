#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'

class PitchCritic < Critic
  def initialize(order)
    @markov_chain = MarkovChain.new(order, Pitch.num_values)
  end

  def reset
    @markov_chain.reset
  end

  def listen(note)
    raise ArgumentError.new("not a note.  is a #{note.class}") if note.class != Note
    next_symbol = note.pitch.to_symbol
    surprise = @markov_chain.get_expectations.get_surprise(next_symbol.val)
    @markov_chain.observe(next_symbol.val)
    @markov_chain.transition(next_symbol.val)
    return surprise
  end

  def get_expectations
    r = @markov_chain.get_expectations
    symbol_to_outcome = lambda { |x| PitchSymbol.new(x).to_object.val }
    outcome_to_symbol = lambda { |x| Pitch.new(x).to_symbol.val }
    r.transform_outcomes(symbol_to_outcome, outcome_to_symbol)
    return r
  end
end
