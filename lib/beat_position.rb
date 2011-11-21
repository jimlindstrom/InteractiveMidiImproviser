class BeatPosition
  attr_accessor :measure, :beat, :beats_per_measure, :subbeat, :subbeats_per_beat

  def self.num_values
    ranges = []
    ranges.push Array(0..11).length # beat
    ranges.push [1, 2, 3, 4].length # subbeat
    ranges.push Array(2..12).length # beats_per_measure
    ranges.push [1, 2, 4].length # subbeats_per_beat
    return ranges.inject(:*)
  end

  def to_symbol
    v  = @beat
    v *= Array(0..11).length 

    v += [1, 2, 3, 4].index(@subbeat)
    v *= [1, 2, 3, 4].length

    v += Array(2..12).index(@beats_per_measure)
    v *= Array(2..12).length

    v += [1, 2, 4].index(@subbeats_per_beat)

    return BeatPositionSymbol.new(v)
  end

  def to_hash
    return {:measure=>@measure, :beat=>@beat, :subbeat=>@subbeat}
  end
end
