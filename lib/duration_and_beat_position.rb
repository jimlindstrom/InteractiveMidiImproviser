class DurationAndBeatPosition
  attr_accessor :duration, :beat_position

  def self.num_values
    return Duration.num_values * BeatPosition.num_values
  end

  def initialize(d=nil, bp=nil)
    @duration      = d
    @beat_position = bp
  end

  def to_symbol
    v  = @duration.to_symbol.val

    v *= BeatPosition.num_values
    v += @beat_position.to_symbol.val

    return DurationAndBeatPositionSymbol.new(v)
  end
end
