#!/usr/bin/env ruby 

#require 'interactive_improvisor_lib'

class RandomVariable
  def initialize(num_outcomes)
    raise ArgumentError.new("num_outcomes must be >= 1") if num_outcomes < 1

    @num_outcomes        = num_outcomes
    @num_observations    = 0
    @observations        = [0]*num_outcomes
    @cdf                 = [0]*num_outcomes
    @outcome_transformer = lambda { |x| x } 
  end

  def transform_outcomes(t)
    @outcome_transformer = t
  end

  def +(r)
    o = get_possible_transformed_outcomes
    o += r.get_possible_transformed_outcomes

    omax = o.map{|x| x[:outcome] }.max
    omin = o.map{|x| x[:outcome] }.min
    num_outcomes = (omax || 0) - (omin || 0) + 1
    outcome_transformer = lambda{|x| x + omin}

    rnew = RandomVariable.new(num_outcomes)
    o.each do |x|
      rnew.add_possible_outcome(x[:outcome] - omin, x[:num_observations])
    end
    rnew.transform_outcomes(outcome_transformer)

    return rnew
  end

  def add_possible_outcome(outcome, num_observations)
    raise ArgumentError.new("num_observations must be >= 0") if num_observations < 0

    @observations[outcome] += num_observations
    @num_observations      += num_observations

    # update the CDF
    (outcome..(@cdf.length-1)).each do |idx|
      @cdf[idx] += num_observations
    end
  end

  def choose_outcome
    # we can't generate anything w/o any observations
    return nil if @num_observations == 0

    # generate a outcome, based on the CDF
    r = (rand*(@num_observations-1)).round + 1 # I have some doubt about the final "+ 1"...
    outcome = @cdf.length+1
    (0..(@cdf.length-1)).each do |idx|
      if r <= @cdf[idx]
        outcome = [outcome, idx].min
      end
    end
    raise RuntimeError.new("outcome out of bounds") if outcome > @cdf.length # is this even possible??

    return @outcome_transformer.call(outcome)
  end

  def get_surprise(transformed_outcome)
    return 0.5 if @num_observations == 0

    outcome = nil
    (0..(@num_outcomes-1)).each do |cur_outcome|
      if @outcome_transformer.call(cur_outcome) == transformed_outcome # this assumes that 'cur_outcome' is an IntervalSymbol
        outcome = cur_outcome
      end
    end
    raise RuntimeError.new("outcome not found") if outcome.nil?

    cur_expectation = @observations[outcome]
    max_expectation = @observations.max
    surprise = (max_expectation - cur_expectation).to_f / max_expectation

    return surprise
  end

  protected

  def get_possible_transformed_outcomes
    o = []
    (0..(@observations.length-1)).each do |x|
      if @observations[x] > 0
        o.push({:outcome => @outcome_transformer.call(x), :num_observations => @observations[x] })
      end
    end
    return o
  end

end
