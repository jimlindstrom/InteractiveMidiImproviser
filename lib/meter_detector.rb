#!/usr/bin/env ruby

class MeterDetectorParams
  attr_accessor :weights, :off_tactus_penalty, :duration_exponent
  attr_accessor :switches

  def initialize
    @weights = { "[3, 4]" => [3, 1, 1],
                 "[4, 4]" => [4, 1, 2, 1] }
  
    @off_tactus_penalty = -0.6

    @duration_exponent = 1

    @switches = [false] * 4
  end

  def self.new_random
    p = MeterDetectorParams.new

    p.off_tactus_penalty =  -2*rand*rand

    p.weights["[3, 4]"] = [20*rand, 10*rand, 10*rand]
    p.weights["[4, 4]"] = [20*rand, 10*rand, 12*rand, 10*rand]

    p.weights["[3, 4]"].map!{ |x| [p.weights["[3, 4]"].first, x].min }
    p.weights["[4, 4]"].map!{ |x| [p.weights["[4, 4]"].first, x].min }

    p.duration_exponent = rand*rand*6

    p.switches = (0..3).collect{ rand>0.5 }

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

    p.switches = a.switches.zip(b.switches).map do |x, y|
      if x == y
        if rand > 0.95
          !x
        else
          x
        end
      elsif rand > 0.5
        true
      else
        false
      end
    end

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
    self.map!{ |x| x/Float(self.sum) } if false #$meter_detector_params.switches[0]
    self.map!{ |x| x/Float(orig_sum) } if false #$meter_detector_params.switches[1]
    self.map!{ |x| x*(self.length) }   if false #$meter_detector_params.switches[2]
    self.map!{ |x| x*(orig_len) }      if false #$meter_detector_params.switches[3]

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

  def calculate(duration_arr)
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

end

