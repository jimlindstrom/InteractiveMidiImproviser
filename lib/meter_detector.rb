#!/usr/bin/env ruby

class MeterDetectorWeights < Array
  def expand(multiplier, off_tactus_penalty)
    self.map!{ |x| [x]+([off_tactus_penalty]*(multiplier-1.0)) }
    self.flatten!
  end
  def normalize
    self.map!{ |x| x/Float(self.sum) }
    self.map!{ |x| x*(self.length) }
  end
  def sum
    self.inject(:+)
  end
end

class MeterDetector
  attr_accessor :time_sig, :multiplier

  def initialize(time_sig, weights, multiplier)
    @period = time_sig[0] * multiplier

    @correlations = [0] * @period

    off_tactus_penalty = -0.6
    @weights = MeterDetectorWeights.new(weights)
    @weights.expand(multiplier, off_tactus_penalty)
    @weights.normalize
  end

  def calculate(duration_arr)
    index = 0
    duration_arr.each do |d|
      @correlations[index] += d
      index = (index + d) % @period
    end

    scores = []
    (0..(@period-1)).each do |offset|
      scores.push({ :offset => offset, :score => @correlations.zip(@weights).map{|x,y| x*y}.inject(:+) })

      r = @correlations.pop
      @correlations.unshift r
    end

    return scores.sort{|x,y| x[:score] <=> y[:score]}.last
  end

end

