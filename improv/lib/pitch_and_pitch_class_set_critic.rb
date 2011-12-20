#!/usr/bin/env ruby

class PitchAndPitchClassSetCritic < Critic
  def initialize(order)
    reset_cumulative_surprise
    @markov_chain = Math::AsymmetricMarkovChain.new(order, 
                                                    num_states=Music::PitchAndPitchClassSet.num_values, 
                                                    num_outcomes=Music::Pitch.num_values)
    reset
  end

  def reset
    @markov_chain.reset
    @note_history = []
  end

  def save(folder)
    filename = "#{folder}/pitch_and_pitch_class_set_critic_#{@markov_chain.order}.yml"
    @markov_chain.save(filename)

    filename = "#{folder}/pitch_and_pitch_class_set_critic_#{@markov_chain.order}_note_history.yml"
    File.open(filename, 'w') { |f| f.puts YAML::dump @note_history }
  end

  def load(folder)
    filename = "#{folder}/pitch_and_pitch_class_set_critic_#{@markov_chain.order}.yml"
    @markov_chain = Math::AsymmetricMarkovChain.load(filename)

    filename = "#{folder}/pitch_and_pitch_class_set_critic_#{@markov_chain.order}_note_history.yml"
    File.open(filename, 'r') { |f| @note_history = YAML::load(f) }
  end

  def listen(note)
    raise ArgumentError.new("not a note.  is a #{note.class}") if note.class != Music::Note

    @note_history.push note
    pcs = current_pitch_class_set

    next_state   = Music::PitchAndPitchClassSet.new(note.pitch, pcs).to_symbol
    next_outcome = note.pitch.to_symbol

    surprise = @markov_chain.get_expectations.get_surprise(next_outcome.val)
    add_to_cumulative_surprise surprise
    @markov_chain.observe(next_outcome.val)
    @markov_chain.transition(next_state.val)
    return surprise
  end

  def get_expectations
    r = @markov_chain.get_expectations
    symbol_to_outcome = lambda { |x| Music::PitchSymbol.new(x).to_object.val }
    outcome_to_symbol = lambda { |x| Music::Pitch.new(x).to_symbol.val }
    r.transform_outcomes(symbol_to_outcome, outcome_to_symbol)
    return r
  end

  def current_pitch_class_set
    pcs = Music::PitchClassSet.new

    note_idx = @note_history.length-1
    while pcs.vals.length < @markov_chain.order and note_idx >= 0
      pcs.add(Music::PitchClass.from_pitch(@note_history[note_idx].pitch))
      note_idx -= 1
    end

    return pcs
  end
end
