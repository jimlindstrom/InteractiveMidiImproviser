#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'

class IntervalCritic < Critic
  def initialize(order)
    @markov_chain = MarkovChain.new(order, Interval.num_values)
    @note_history = []
  end

  def reset
    @markov_chain.reset
    @note_history = []
  end

  def listen(note)
    raise ArgumentError.new("not a note.  is a #{note.class}") if note.class != Note

    @note_history.unshift note
    if @note_history.length >= 2
      interval = Interval.calculate(@note_history[-1].pitch, @note_history[-2].pitch)
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
    r.transform_outcomes lambda { |x| IntervalSymbol.new(x).to_object.val }
    return r
  end
end
