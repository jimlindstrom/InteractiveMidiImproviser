#!/usr/bin/env ruby

require 'yaml'

module Math
  
  class AsymmetricMarkovChain
    attr_reader :order

    def initialize(order, num_states, num_outcomes)
      raise ArgumentError.new("order must be positive") if order < 1
      raise ArgumentError.new("must have two or more states") if num_states < 2
      raise ArgumentError.new("must have two or more outcomes") if num_outcomes < 2
  
      @order = order
      @num_states = num_states
      @num_outcomes = num_outcomes
  
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
        f.puts YAML::dump @num_outcomes
        f.puts YAML::dump @observations
        f.puts YAML::dump @state_history
        f.puts YAML::dump @state_history_string
      end
    end

    def self.load(filename)
      docs = []
      File.open(filename, 'r') do |f|
        YAML.each_document(f) { |d| docs.push d }
      end
      raise RuntimeError.new("bad markov file") if docs.length != 6

      m = AsymmetricMarkovChain.new(docs[0], docs[1], docs[2])
      m.set_internals(docs[3], docs[4], docs[5])

      return m
    end
  
    def observe(outcome)
      raise ArgumentError.new("outcome must be in 0..(num_outcomes-1) range") if (outcome < 0) or (outcome >= @num_outcomes)
  
      k = state_history_to_key
      if @observations[k].nil?
        @observations[k] = {}
      end
      if @observations[k][outcome].nil?
        @observations[k][outcome] = 0
      end
      @observations[k][outcome] += 1
    end
  
    def transition(next_state)
      raise ArgumentError.new("state must be in 0..(num_states-1) range") if (next_state < 0) or (next_state >= @num_states)
  
      @state_history.push next_state
      @state_history.shift
  
      @state_history_string.push String(next_state || "nil")
      @state_history_string.shift
    end
  
    def get_expectations
      x = RandomVariable.new(@num_outcomes)
      k = state_history_to_key
      (@observations[k] || {}).each do |outcome, num_observations|
        x.add_possible_outcome(outcome, num_observations)
      end
      return x
    end

  # FIXME: This is terrible.  How else can (only) self.load set these though?
    def set_internals(o, sh, shs)
      @observations         = o
      @state_history        = sh
      @state_history_string = shs
    end

  private
    def state_history_to_key
      @state_history_string.join(',')
    end
  
  end
  
end
