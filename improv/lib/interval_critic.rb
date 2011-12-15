#!/usr/bin/env ruby

class IntervalCritic < Critic
  def initialize(order)
    @markov_chain = MarkovChain.new(order, Music::Interval.num_values)
    @note_history = []
  end

  def reset
    @markov_chain.reset
    @note_history = []
  end

  def listen(note)
    raise ArgumentError.new("not a note.  is a #{note.class}") if note.class != Music::Note

    @note_history.unshift note
    if @note_history.length >= 2
      interval = Music::Interval.calculate(@note_history[-1].pitch, @note_history[-2].pitch)
      @note_history.pop
      next_symbol = interval.to_symbol

      surprise = @markov_chain.get_expectations.get_surprise(next_symbol.val)
      @markov_chain.observe(next_symbol.val)
      @markov_chain.transition(next_symbol.val)
      return surprise
    end
    return nil
  end

  def get_expectations
    return nil if @note_history.empty?

    r = @markov_chain.get_expectations
    symbol_to_outcome = lambda { |x| Music::IntervalSymbol.new(x).to_object.val + @note_history[-1].pitch.val }
    outcome_to_symbol = lambda { |x| Music::Interval.new(x - @note_history[-1].pitch.val).to_symbol.val }
    r.transform_outcomes(symbol_to_outcome, outcome_to_symbol)
    return r
  end
end
