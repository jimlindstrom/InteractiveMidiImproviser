#!/usr/bin/env ruby

module Music

  class DistInterval
    MAX_PITCH_DELTA    = 15
    MAX_DURATION_DELTA =  8

    PITCH_WEIGHT    = 0.5
    DURATION_WEIGHT = 0.5

    attr_reader :d

    def initialize(first_note, second_note)
      @pitch_dist    = normalize_dist(second_note.pitch.val    - first_note.pitch.val,    MAX_PITCH_DELTA)
      @duration_dist = normalize_dist(second_note.duration.val - first_note.duration.val, MAX_DURATION_DELTA)
      @d             = (PITCH_WEIGHT * @pitch_dist) + (DURATION_WEIGHT * @duration_dist)
    end

    private

    def normalize_dist(x, max_x)
      if x > max_x
        y = max_x
      elsif x < -max_x
        y = -max_x
      else
        y = x
      end
      return y*y
    end
  end

end

