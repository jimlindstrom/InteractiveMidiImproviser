#!/usr/bin/env ruby

require 'markov/state'

module Markov

  class Chain
    def initialize(num_states)
      @num_states = num_states
  
      @initial_state = Markov::State.new(@num_states)
      @states = []
      (0..(@num_states-1)).each do |idx|
        @states[idx] = Markov::State.new(@num_states)
      end
      @no_observations_yet = true
    end
  
    def add_observation(s)
      @no_observations_yet = false
      surprise = 0.0
  
      cur_state = @initial_state
      s.each do |next_state_idx|
        surprise = surprise + cur_state.add_observation(next_state_idx)
        cur_state = @states[next_state_idx]
      end
  
      return surprise
    end
    
    def generate_next(history)
      return nil if @no_observations_yet
      return @initial_state.generate if history == []
      return @states[history.last].generate
    end

    def evaluate_next(history, next_state)
      return { :surprise => @initial_state.calc_surprise(next_state) } if history == []
      return { :surprise => @states[history.last].calc_surprise(next_state) }
    end
    
    def possible_next_states(history)
      return nil if @no_observations_yet
      return @initial_state.possible_next_states if history == []
      return @states[history.last].possible_next_states
    end

  end
  
end

