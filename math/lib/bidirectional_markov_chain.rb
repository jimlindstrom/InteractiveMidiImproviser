#!/usr/bin/env ruby

require 'yaml'

module Math
  
  class BidirectionalMarkovChain
    attr_reader :order

    LOGGING = false

    def initialize(order, lookahead, num_states)
      raise ArgumentError.new("order must be positive") if order < 1
      raise ArgumentError.new("must have two or more states") if num_states < 2
      raise ArgumentError.new("must have a lookahead of 1 or more") if lookahead < 1
  
      @order = order
      @lookahead = lookahead 
      @num_states = num_states
  
      @observations = {}
  
      reset
    end
   
    def current_state
      return @state_history.last
    end

    def steps_left
      return @steps_left
    end
   
    def reset
      @steps_left           = nil
      @state_history        = [ nil ]*@order
      @state_history_string = ["nil"]*@order
    end
  
    def save(filename)
      File.open(filename, 'w') do |f| 
        f.puts YAML::dump @order
        f.puts YAML::dump @lookahead
        f.puts YAML::dump @num_states
        f.puts YAML::dump @observations
        f.puts YAML::dump @state_history
        f.puts YAML::dump @state_history_string
        f.puts YAML::dump @steps_left
      end
    end

    def self.load(filename)
      docs = []
      File.open(filename, 'r') do |f|
        YAML.each_document(f) { |d| docs.push d }
      end
      raise RuntimeError.new("bad markov file") if docs.length != 7

      m = BidirectionalMarkovChain.new(docs[0], docs[1], docs[2])
      m.set_internals(docs[3], docs[4], docs[5], docs[6])

      return m
    end
  
    def observe(next_state, steps_left)
      raise ArgumentError.new("state must be in 0..(num_states-1) range") if (next_state < 0) or (next_state >= @num_states)
	  raise ArgumentError.new("steps_left cannot be negative") if (steps_left < 0)
      raise ArgumentError.new("steps_left expected to be #{@steps_left-1}") if !@steps_left.nil? and (steps_left != (@steps_left-1))
  
      k = state_history_to_key
      puts "observe    k: " + k.inspect + " => #{next_state},#{steps_left}" if LOGGING
      if @observations[k].nil?
        @observations[k] = {}
      end
      if @observations[k][next_state].nil?
        @observations[k][next_state] = 0
      end
      @observations[k][next_state] += 1
    end
  
    def transition(next_state, steps_left)
      raise ArgumentError.new("state must be in 0..(num_states-1) range") if (next_state < 0) or (next_state >= @num_states)
	  raise ArgumentError.new("steps_left cannot be negative") if (steps_left < 0)
      raise ArgumentError.new("steps_left expected to be #{@steps_left-1}") if !@steps_left.nil? and (steps_left != (@steps_left-1))
  
      @state_history.push next_state
      @state_history.shift
  
      @state_history_string.push String(next_state || "nil")
      @state_history_string.shift

      puts "transition k: " + state_history_to_key.inspect + " (before)" if LOGGING
      @steps_left = steps_left if steps_left <= @lookahead
      puts "transition k: " + state_history_to_key.inspect + " (after)" if LOGGING
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

  # FIXME: This is terrible.  How else can (only) self.load set these though?
    def set_internals(o, sh, shs, sl)
      @observations         = o
      @state_history        = sh
      @state_history_string = shs
      @steps_left           = sl
    end

  private
    def state_history_to_key
      @state_history_string.join(',') + ',' + String(@steps_left || "nil")
    end
  
  end
  
end
