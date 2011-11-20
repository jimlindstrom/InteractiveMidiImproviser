#!/usr/bin/env ruby

class MeterDetectorParams
  attr_accessor :weights, :off_tactus_penalty, :duration_exponent

  def initialize
    @weights = { "[3, 4]" => [3, 1, 1],
                 "[4, 4]" => [4, 1, 2, 1] }
  
    @off_tactus_penalty = -0.6

    @duration_exponent = 1
  end

  def self.new_random
    p = MeterDetectorParams.new

    p.off_tactus_penalty =  -2*rand*rand

    p.weights["[3, 4]"] = [20*rand, 10*rand, 10*rand]
    p.weights["[4, 4]"] = [20*rand, 10*rand, 12*rand, 10*rand]

    p.weights["[3, 4]"].map!{ |x| [p.weights["[3, 4]"].first, x].min }
    p.weights["[4, 4]"].map!{ |x| [p.weights["[4, 4]"].first, x].min }

    p.duration_exponent = rand*rand*6

    return p
  end

  def self.merge(a, b)
    p = MeterDetectorParams.new

    p.off_tactus_penalty = (a.off_tactus_penalty + b.off_tactus_penalty)/2.0
    p.off_tactus_penalty += 0.4*rand - 0.2

    p.weights["[3, 4]"] = a.weights["[3, 4]"].zip(b.weights["[3, 4]"]).map{ |x,y| (x+y)/2.0 + rand-0.5 }
    p.weights["[4, 4]"] = a.weights["[4, 4]"].zip(b.weights["[4, 4]"]).map{ |x,y| (x+y)/2.0 + rand-0.5 }

    p.weights["[3, 4]"].map!{ |x| [0, [p.weights["[3, 4]"].first, x].min].max }
    p.weights["[4, 4]"].map!{ |x| [0, [p.weights["[4, 4]"].first, x].min].max }

    p.duration_exponent = (a.duration_exponent+b.duration_exponent)/2.0 + ((0.2*rand)-0.1)

    return p
  end
end

$meter_detector_params = MeterDetectorParams.new

class MeterDetectorWeights < Array
  def expand(multiplier, off_tactus_penalty)
    orig_len = self.length
    orig_sum = self.sum

    self.map!{ |x| [x]+([off_tactus_penalty]*(multiplier-1.0)) }
    self.flatten!
    self.map!{ |x| x/Float(self.sum) } if false 
    self.map!{ |x| x/Float(orig_sum) } if false
    self.map!{ |x| x*(self.length) }   if false
    self.map!{ |x| x*(orig_len) }      if false

    self.map!{ |x| x/Float(self.sum) } # normalize
  end
  def sum
    return self.inject(:+)
  end
end

class MeterDetector
  attr_accessor :time_sig, :multiplier

  def initialize(time_sig, multiplier)
    @period = time_sig[0] * multiplier

    @correlations = [0] * @period

    @raw_weights = $meter_detector_params.weights[time_sig.to_s]
    @weights = MeterDetectorWeights.new(@raw_weights)
    @weights.expand(multiplier, $meter_detector_params.off_tactus_penalty)
  end

  def _calculate(duration_arr) # original
    index = 0
    duration_arr.each do |d|
      @correlations[index] += d**$meter_detector_params.duration_exponent
      index = (index + d) % @period
    end

    scores = []
    (0..(@period-1)).each do |offset|
      scores.push({ :weights => @raw_weights,
                    :offset  => offset, 
                    :score   => @correlations.zip(@weights).map{|x,y| x*y}.inject(:+) })

      r = @correlations.pop
      @correlations.unshift r
    end

    return scores.sort{|x,y| x[:score] <=> y[:score]}.last
  end

  def __calculate(duration_arr) # 2nd attempt
    onset_arr = []
    duration_arr.each do |d|
      onset_arr.push d**$meter_detector_params.duration_exponent
      (d-1).times do 
        onset_arr.push 0
      end
    end

    scores = []
    (0..(@period-1)).each do |offset|
      score = 0.0
      (0..(onset_arr.size-1)).each do |idx|
        score += onset_arr[idx] * @weights[(idx+offset) % @weights.size]
      end

      scores.push({ :weights => @raw_weights,
                    :offset  => offset, 
                    :score   => score })
    end

    return scores.sort{|x,y| x[:score] <=> y[:score]}.last
  end

  def ___calculate(duration_arr) # 3rd pass
    @correlations.map!{ |x| 1 } # convert them all to one-based
    index = 0
    duration_arr.each do |d|
      @correlations[index] = @correlations[index] * d**$meter_detector_params.duration_exponent
      index = (index + 1) % @period
      (d-1).times do
        @correlations[index] = @correlations[index] * 0.95
        index = (index + 1) % @period
      end
    end

    scores = []
    (0..(@period-1)).each do |offset|
      scores.push({ :weights => @raw_weights,
                    :offset  => offset, 
                    :score   => @correlations.zip(@weights).map{|x,y| x*y}.inject(:+) })

      r = @correlations.pop
      @correlations.unshift r
    end

    return scores.sort{|x,y| x[:score] <=> y[:score]}.last
  end

  def calculate(duration_arr) # 4th attempt
    onset_arr = []
    duration_arr.each do |d|
      onset_arr.push d**$meter_detector_params.duration_exponent
      (d-1).times do 
        onset_arr.push 0
      end
    end

    scores = []
    (0..(@period-1)).each do |offset|
      score = 0.0
      (0..(onset_arr.size-1)).each do |idx|
        score += onset_arr[idx] * @weights[(idx+offset) % @weights.size]
      end

      scores.push({ :weights => @raw_weights,
                    :offset  => offset, 
                    :score   => score })
    end

    return scores.sort{|x,y| x[:score] <=> y[:score]}.last
  end

end

