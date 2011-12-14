#!/usr/bin/env ruby

module Music

  class DurationAndBeatPosition
    attr_accessor :duration, :beat_position
  
    def self.num_values
      return Duration.num_values * BeatPosition.num_values
    end
  
    def initialize(*params)
      @duration      = Duration.new(0)
      @beat_position = BeatPosition.new
      if params.length==1
        h = params[0]
        @duration.set_val                  h[:duration]
        @beat_position.beat              = h[:beat]
        @beat_position.subbeat           = h[:subbeat]
        @beat_position.beats_per_measure = h[:beats_per_measure]
        @beat_position.subbeats_per_beat = h[:subbeats_per_beat]
      elsif params.length==5
        h = Hash[params]
        @duration.set_val                  h[:duration]
        @beat_position.beat              = h[:beat]
        @beat_position.subbeat           = h[:subbeat]
        @beat_position.beats_per_measure = h[:beats_per_measure]
        @beat_position.subbeats_per_beat = h[:subbeats_per_beat]
      elsif params.length==2
        @duration      = params[0]
        @beat_position = params[1]
      else
        raise ArgumentError.new("Bad params: #{params.inspect}")
      end
    end
  
    def val # this is only used to compare equality. FIXME: it might also be used to instantiate
      v = {}
      v[:duration] = @duration.val
      v[:beat] = @beat_position.beat
      v[:subbeat] = @beat_position.subbeat
      v[:beats_per_measure] = @beat_position.beats_per_measure
      v[:subbeats_per_beat] = @beat_position.subbeats_per_beat
      return v
    end
  
    def to_symbol
      v  = @duration.to_symbol.val
  
      v *= BeatPosition.num_values
      v += @beat_position.to_symbol.val
  
      return DurationAndBeatPositionSymbol.new(v)
    end
  end
  
end
