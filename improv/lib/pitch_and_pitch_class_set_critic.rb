#!/usr/bin/env ruby

class PitchAndPitchClassSetCritic < Critic
  def initialize(order, lookahead)
    reset_cumulative_surprise
    @markov_chain = Math::AsymmetricBidirectionalMarkovChain.new(order, 
                                                                 lookahead, 
                                                                 num_states=Music::PitchAndPitchClassSet.num_values, 
                                                                 num_outcomes=Music::Pitch.num_values)
    puts "lookahead1: #{@markov_chain.lookahead}"
    reset
  end

  def reset
    @markov_chain.reset
    @note_history = []
  end

  def save(folder)
    filename = "#{folder}/pitch_and_pitch_class_set_critic_#{@markov_chain.order}_#{@markov_chain.lookahead}.yml"
    @markov_chain.save(filename)

    filename = "#{folder}/pitch_and_pitch_class_set_critic_#{@markov_chain.order}_#{@markov_chain.lookahead}_note_history.yml"
    File.open(filename, 'w') { |f| f.puts YAML::dump @note_history }
  end

  def load(folder)
    puts "lookahead2: #{@markov_chain.lookahead}"
    filename = "#{folder}/pitch_and_pitch_class_set_critic_#{@markov_chain.order}_#{@markov_chain.lookahead}.yml"
    @markov_chain = Math::AsymmetricBidirectionalMarkovChain.load(filename)

    puts "lookahead3: #{@markov_chain.lookahead}"
    filename = "#{folder}/pitch_and_pitch_class_set_critic_#{@markov_chain.order}_#{@markov_chain.lookahead}_note_history.yml"
    File.open(filename, 'r') { |f| @note_history = YAML::load(f) }
  end

  def listen(note)
    raise ArgumentError.new("not a note.  is a #{note.class}") if note.class != Music::Note
    raise ArgumentError.new("note must have notes_left analysis") if note.analysis[:notes_left].nil?

    @note_history.push note
    pcs = current_pitch_class_set

    next_state   = Music::PitchAndPitchClassSet.new(note.pitch, pcs).to_symbol
    next_outcome = note.pitch.to_symbol

    surprise = @markov_chain.get_expectations.get_surprise(next_outcome.val)
    add_to_cumulative_surprise surprise
    @markov_chain.observe(next_outcome.val, note.analysis[:notes_left])
    @markov_chain.transition(next_state.val, note.analysis[:notes_left])
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
    wpcs = Music::WeightedPitchClassSet.new()
    weight = 1.0
    (@note_history.length-1).downto(0) do |note_idx|
      cur_note=@note_history[note_idx]
      wpcs.add(Music::PitchClass.from_pitch(cur_note.pitch), weight*cur_note.duration.val)
      weight *= 0.9
    end

    return wpcs.top_n_pitch_classes(@markov_chain.order)
  end
end
