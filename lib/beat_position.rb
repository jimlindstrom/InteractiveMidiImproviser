class BeatPosition
  attr_accessor :measure, :beat, :num_beats, :subdiv, :num_subdivs

  def to_hash
    return {:measure=>@measure, :beat=>@beat, :subdiv=>@subdiv}
  end
end
