#!/usr/bin/env ruby

module Music

  class LBDMInterval
    MAX_PITCH_DELTA    = 15
    MAX_DURATION_DELTA =  8

    PITCH_WEIGHT    = 0.5
    DURATION_WEIGHT = 0.5

    attr_reader :x
    attr_accessor :prev_interval
    attr_accessor :next_interval

    def initialize(first_note, second_note)
      @pitch_delta    = normalize_delta(second_note.pitch.val    - first_note.pitch.val,    MAX_PITCH_DELTA)
      @duration_delta = normalize_delta(second_note.duration.val - first_note.duration.val, MAX_DURATION_DELTA)
      @x              = (PITCH_WEIGHT * @pitch_delta) + (DURATION_WEIGHT * @duration_delta)

      @prev_interval = nil
      @next_interval = nil
    end

    def r_before
      numerator   = (x_prev - x).abs
      denominator =  x_prev + x
      return 0.0 if denominator == 0.0
      return numerator.to_f / denominator
    end

    def r_after
      numerator   = (x - x_next).abs
      denominator =  x + x_next
      return 0.0 if denominator == 0.0
      return numerator.to_f / denominator
    end

    def s
      return x * (r_before + r_after)
    end

    private

    def x_next
      return 0.5 if @next_interval.nil?
      return @next_interval.x
    end

    def x_prev
      return 0.5 if @prev_interval.nil?
      return @prev_interval.x
    end

    def normalize_delta(x, max_x)
      if x > max_x
        y = max_x
      elsif x < -max_x
        y = -max_x
      else
        y = x
      end
      return (y + max_x.to_f) / (2.0*max_x.to_f)
    end
  end

end

