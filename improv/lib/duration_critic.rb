#!/usr/bin/env ruby

class DurationCritic < Critic
  def initialize(order)
    @markov_chain = Math::MarkovChain.new(order, Music::Duration.num_values)
  end

  def reset
    @markov_chain.reset
  end

  def save(folder)
    filename = "#{folder}/duration_critic_#{@markov_chain.order}.yml"
    @markov_chain.save(filename)
  end

  def listen(note)
    raise ArgumentError.new("not a note.  is a #{note.class}") if note.class != Music::Note
    next_symbol = note.duration.to_symbol
    surprise = @markov_chain.get_expectations.get_surprise(next_symbol.val)
    @markov_chain.observe(next_symbol.val)
    @markov_chain.transition(next_symbol.val)
    return surprise
  end

  def get_expectations
    r = @markov_chain.get_expectations
    symbol_to_outcome = lambda { |x| Music::DurationSymbol.new(x).to_object.val }
    outcome_to_symbol = lambda { |x| Music::Duration.new(x).to_symbol.val }
    r.transform_outcomes(symbol_to_outcome, outcome_to_symbol)
    return r
  end
end
