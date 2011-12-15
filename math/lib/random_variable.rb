#!/usr/bin/env ruby 

module Math
  
  class RandomVariable
    LOGGING = false
  
    def initialize(num_outcomes)
      raise ArgumentError.new("num_outcomes must be >= 1") if num_outcomes < 1
  
      @num_outcomes          = num_outcomes
      @num_observations      = 0
      @observations          = [0]*num_outcomes
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
    end
  
    def choose_outcome
      # we can't generate anything w/o any observations
      puts "no observations" if @num_observations == 0 and LOGGING
      return nil if @num_observations == 0
  
      # generate a outcome, based on the CDF
      orig_r = r = (rand*(@num_observations-1.0)).round
  
      outcome = 0
      while outcome < @num_outcomes
        if @observations[outcome] > 0
          if r < @observations[outcome]
            puts "choosing #{outcome} => #{@outcome_transformer.call(outcome)}" if LOGGING
            return @outcome_transformer.call(outcome)
          end
          r -= @observations[outcome]
        end
  
        outcome += 1
      end
  
      raise RuntimeError.new("RandomVariable couldn't choose outcome for orig_r=#{orig_r}, num_outcomes=#{@num_outcomes}") if LOGGING
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
  
  end

end
