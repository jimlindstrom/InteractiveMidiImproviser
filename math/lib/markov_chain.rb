#!/usr/bin/env ruby

require 'yaml'

module Math
  
  class MarkovChain
    attr_reader :order
  
    def initialize(order, num_states)
      raise ArgumentError.new("order must be positive") if order < 1
      raise ArgumentError.new("must have two or more states") if num_states < 2
  
      @order = order
      @num_states = num_states
  
      @observations = {}
  
      reset
    end
  
    def current_state
      return @state_history.last
    end
   
    def reset
      @state_history        = [ nil ]*@order
      @state_history_string = ["nil"]*@order
    end
 
    def save(filename)
      File.open(filename, 'w') do |f| 
        f.puts YAML::dump @order
        f.puts YAML::dump @num_states
        f.puts YAML::dump @observations
        f.puts YAML::dump @state_history
        f.puts YAML::dump @state_history_string
      end
    end
  
    def observe(next_state)
      raise ArgumentError.new("state must be in 0..(num_states-1) range") if (next_state < 0) or (next_state >= @num_states)
  
      k = state_history_to_key
      if @observations[k].nil?
        @observations[k] = {}
      end
      if @observations[k][next_state].nil?
        @observations[k][next_state] = 0
      end
      @observations[k][next_state] += 1
    end
  
    def transition(next_state)
      raise ArgumentError.new("state must be in 0..(num_states-1) range") if (next_state < 0) or (next_state >= @num_states)
  
      @state_history.push next_state
      @state_history.shift
  
      @state_history_string.push String(next_state || "nil")
      @state_history_string.shift
    end
  
    def get_expectations
      num_outcomes = @num_states
      x = RandomVariable.new(num_outcomes)
      k = state_history_to_key
      (@observations[k] || {}).each do |next_state, num_observations|
        x.add_possible_outcome(next_state, num_observations)
      end
      return x
    end
  
  private
  
    def state_history_to_key
      @state_history_string.join(',')
    end
  
  end
  
end
