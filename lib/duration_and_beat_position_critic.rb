#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'

class DurationAndBeatPositionCritic < Critic
  def initialize(order)
    @markov_chain = MarkovChain.new(order, DurationAndBeatPosition.num_values)
  end

  def reset
    @markov_chain.reset
  end

  def listen(note)
    raise ArgumentError.new("not a note.  is a #{note.class}") if note.class != Note
    raise ArgumentError.new("note must have meter analysis") if note.analysis[:beat_position].nil?
    next_symbol = DurationAndBeatPosition.new(note.duration, note.analysis[:beat_position]).to_symbol
    surprise = @markov_chain.get_expectations.get_surprise(next_symbol.val)
    @markov_chain.observe(next_symbol.val)
    @markov_chain.transition(next_symbol.val)
    return surprise
  end

  def get_expectations
    r = @markov_chain.get_expectations
    r.transform_outcomes lambda { |x| 
        [ DurationAndBeatPositionSymbol.new(x).to_object.duration, 
          DurationAndBeatPositionSymbol.new(x).to_object.beat_position ] } 

    return r
  end
end
