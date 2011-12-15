#!/usr/bin/env ruby

class DurationAndBeatPositionCritic < Critic
  def initialize(order)
    @markov_chain = Math::MarkovChain.new(order, Music::DurationAndBeatPosition.num_values)
  end

  def reset
    @markov_chain.reset
  end

  def listen(note)
    raise ArgumentError.new("not a note.  is a #{note.class}") if note.class != Music::Note
    raise ArgumentError.new("note must have meter analysis") if note.analysis[:beat_position].nil?
    next_symbol = Music::DurationAndBeatPosition.new(note.duration, note.analysis[:beat_position]).to_symbol
    surprise = @markov_chain.get_expectations.get_surprise(next_symbol.val)
    @markov_chain.observe(next_symbol.val)
    @markov_chain.transition(next_symbol.val)
    return surprise
  end

  def get_expectations
    r = @markov_chain.get_expectations
    symbol_to_outcome = lambda { |x| Music::DurationAndBeatPositionSymbol.new(x).to_object.val }
    outcome_to_symbol = lambda { |x| Music::DurationAndBeatPosition.new(x).to_symbol.val }
    r.transform_outcomes(symbol_to_outcome, outcome_to_symbol)
    return r
  end
end
