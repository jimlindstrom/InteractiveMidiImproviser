#!/usr/bin/env ruby 

#require 'interactive_improvisor_lib'

class RandomVariable
  LOGGING = false

  def initialize(num_outcomes)
    raise ArgumentError.new("num_outcomes must be >= 1") if num_outcomes < 1

    @num_outcomes          = num_outcomes
    @num_observations      = 0
    @observations          = [0]*num_outcomes
    @cdf                   = [0]*num_outcomes
    @outcome_transformer   = lambda { |x| x } 
    @outcome_untransformer = lambda { |x| x } 
  end

  def transform_outcomes(t, un_t)
    @outcome_transformer   = t
    @outcome_untransformer = un_t
  end

  def +(r)
    o = get_possible_transformed_outcomes
    o += r.get_possible_transformed_outcomes

    omax = o.map{|x| x[:outcome] }.max
    omin = o.map{|x| x[:outcome] }.min
    num_outcomes = (omax || 0) - (omin || 0) + 1
    outcome_transformer   = lambda{|x| x + omin}
    outcome_untransformer = lambda{|x| x - omin}

    rnew = RandomVariable.new(num_outcomes)
    o.each do |x|
      rnew.add_possible_outcome(x[:outcome] - omin, x[:num_observations])
    end
    rnew.transform_outcomes(outcome_transformer, outcome_untransformer)

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
    puts "no observations" if @num_observations == 0 and LOGGING
    return nil if @num_observations == 0

    # generate a outcome, based on the CDF
    r = (rand*(@num_observations-1)).round + 1 # I have some doubt about the final "+ 1"...
    outcome = find(r)
    raise RuntimeError.new("outcome out of bounds") if outcome.nil? # is this even possible??

    puts "choosing #{outcome} => #{@outcome_transformer.call(outcome)}" if LOGGING
    return @outcome_transformer.call(outcome)
  end

  def get_surprise(transformed_outcome)
    return 0.5 if @num_observations == 0

    outcome = @outcome_untransformer.call(transformed_outcome)
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

  def find(goal_val)
    outcome = find_inner(goal_val, 0, @cdf.length-1, nil)
    outcome = 0 if goal_val>=0 and @cdf[0]>goal_val # accomplish this by using 0 instead of nil, in prev. line?
    return nil if outcome.nil?
    while (outcome>0) and (@cdf[outcome-1] == @cdf[outcome])
      outcome -= 1
    end
    return outcome
  end

  def find_inner(goal_val, idx_low, idx_high, idx_best=nil)
    return idx_best if idx_high < idx_low

    idx_mid = (idx_low + idx_high) / 2

    if ((idx_best.nil?) or (@cdf[idx_mid] > @cdf[idx_best])) and (@cdf[idx_mid] <= goal_val)
      idx_best = idx_mid
    end

    if @cdf[idx_mid] > goal_val
      return find_inner(goal_val, idx_low, idx_mid-1, idx_best)
    elsif @cdf[idx_mid] < goal_val
      return find_inner(goal_val, idx_mid+1, idx_high, idx_best)
    else
      return idx_mid
    end
  end

end
