#!/usr/bin/env ruby

class IntervalCritic < Critic
  def initialize(order)
    reset_cumulative_information_content
    @markov_chain = Math::MarkovChain.new(order, Music::Interval.num_values)
    @note_history = []
  end

  def reset
    @markov_chain.reset
    @note_history = []
  end

  def save(folder)
    filename = "#{folder}/interval_critic_#{@markov_chain.order}.yml"
    @markov_chain.save(filename)

    filename = "#{folder}/interval_critic_#{@markov_chain.order}_note_history.yml"
    File.open(filename, 'w') { |f| f.puts YAML::dump @note_history }
  end

  def load(folder)
    filename = "#{folder}/interval_critic_#{@markov_chain.order}.yml"
    @markov_chain = Math::MarkovChain.load(filename)

    filename = "#{folder}/interval_critic_#{@markov_chain.order}_note_history.yml"
    File.open(filename, 'r') { |f| @note_history = YAML::load(f) }
  end

  def listen(note)
    raise ArgumentError.new("not a note.  is a #{note.class}") if note.class != Music::Note

    @note_history.unshift note
    if @note_history.length >= 2
      interval = Music::Interval.calculate(@note_history[-1].pitch, @note_history[-2].pitch)
      @note_history.pop
      next_symbol = interval.to_symbol
	  expectations = @markov_chain.get_expectations
	  if expectations.num_observations > 0
	    information_content = expectations.information_content(next_symbol.val)
	  else
        information_content = Math::RandomVariable.max_information_content
	  end
      add_to_cumulative_information_content information_content
      @markov_chain.observe(next_symbol.val)
      @markov_chain.transition(next_symbol.val)
      return information_content
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
