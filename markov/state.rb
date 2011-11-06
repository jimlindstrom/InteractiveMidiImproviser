#!/usr/bin/env ruby

module Markov

  class State
    def initialize(num_states)
      @num_states       = num_states
      @num_observations = 0
      @observations     = [0]*num_states
      @cdf              = [0]*num_states
    end

    def calc_surprise(next_state)
      cur_expectation = @observations[next_state] 
      max_expectation = @observations.max
      surprise = (max_expectation - cur_expectation) / (@num_observations + 1.0)
    end
   
    def add_observation(next_state)
      surprise = calc_surprise(next_state)
  
      # add the observation
      @observations[next_state] += 1
      @num_observations         += 1
  
      # update the CDF
      l=@num_states-1
      (next_state..l).each do |idx|
        @cdf[idx] = @cdf[idx] + 1
      end
  
      return surprise
    end
 
    def possible_next_states
      next_states = []
      @observations.each_with_index do |val, idx|
        if val > 0
          next_states.push( { :next_state => idx, :num_observations => val } )
        end
      end
      return { :total_observations   => @num_observations,
               :possible_next_states => next_states }
    end
  
    def generate
      # we can't generate anything w/o any observations
      return nil if @num_observations == 0
    
      # generate a next_state, based on the CDF
      r = (rand*(@num_observations-1)).round + 1 # I have some doubt about the final "+ 1"...
      next_state = @cdf.length+1
      (0..(@cdf.length-1)).each do |idx|
        if r <= @cdf[idx]
          next_state = [next_state, idx].min
        end
      end
      next_state = nil if next_state > @cdf.length

      surprise = calc_surprise(next_state)
  
      return { :next_state => next_state, :surprise => surprise }
    end
  end
  
end
