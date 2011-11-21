class BeatPosition
  attr_accessor :measure, :beat, :beats_per_measure, :subbeat, :subbeats_per_beat

  def to_hash
    return {:measure=>@measure, :beat=>@beat, :subbeat=>@subbeat}
  end
end
