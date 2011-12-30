#!/usr/bin/env ruby 

module Math
  
  class RandomVariable
    attr_reader :num_observations, :num_outcomes
    attr_reader :observations

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
 
    def *(r)
      x1 =   get_possible_transformed_outcomes
      x2 = r.get_possible_transformed_outcomes

      o = x1 + x2
      omax = o.map{|x| x[:outcome] }.max
      omin = o.map{|x| x[:outcome] }.min
      num_outcomes = (omax || 0) - (omin || 0) + 1
      outcome_transformer   = lambda{|x| x + omin}
      outcome_untransformer = lambda{|x| x - omin}
  
      rnew = RandomVariable.new(num_outcomes)
      x1.each do |a|
        b = x2.find{|x| x[:outcome]==a[:outcome] }
        if !b.nil?
          rnew.add_possible_outcome(a[:outcome] - omin, a[:num_observations]*b[:num_observations])
        end
      end
      rnew.transform_outcomes(outcome_transformer, outcome_untransformer)
  
      return rnew
    end
    
    def scale(m)
      @observations.map!{ |x| x*m }
      @num_observations *= m
    end

    def add_possible_outcome(outcome, num_observations)
      raise ArgumentError.new("num_observations must be >= 0") if num_observations < 0
      raise ArgumentError.new("outcome must be >= 0") if outcome < 0
      raise ArgumentError.new("outcome must be < #{@num_outcomes}") if outcome >= @num_outcomes
  
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
    
    def probability(transformed_outcome)
      raise RuntimeError.new("probability is undefined without observations") if @num_observations == 0
  
      outcome = @outcome_untransformer.call(transformed_outcome)
      return @observations[outcome].to_f / @num_observations
    end
  
    def get_surprise(transformed_outcome)
      return 0.5 if @num_observations == 0
  
      outcome = @outcome_untransformer.call(transformed_outcome)
      cur_expectation = @observations[outcome]
      max_expectation = @observations.max
      surprise = (max_expectation - cur_expectation).to_f / max_expectation
  
      return surprise
    end

    # This is a more information theoretic version of 'get_surprise' that 
    # returns the amount of informational content associated with a particular
    # outcome, given the context of this state.
    def information_content(transformed_outcome)
      raise RuntimeError.new("information content doesn't make sense without observations") if @num_observations == 0
      p = probability(transformed_outcome)
      return RandomVariable::max_information_content if p < 1.0e-10
      return Math.log2(1.0 / p)
    end

    def self.max_information_content 
      Math.log2(1.0 / (1.0 / 1000000)) # this is arbitrary...
    end

    # The maximum entropy that COULD be observed is a function of the number of 
    # outcomes.  The units of this value is "bits"
    def max_entropy
      Math.log2(@num_outcomes)
    end

    # This has two interpretations: (1) A lower bound on the average number of 
    # bits needed to encode the outcome of this random variable.  (2) The amount 
    # of uncertainty in this context.
    def entropy
      raise RuntimeError.new("entropy is undefined until there are observations") if @num_observations == 0
  
      cur_H = 0.0
      @observations.each do |cur_observations|
        if cur_observations > 0
          cur_probability = cur_observations.to_f / @num_observations
          cur_H -= cur_probability * Math.log2(cur_probability)
        end
      end
  
      return cur_H
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

