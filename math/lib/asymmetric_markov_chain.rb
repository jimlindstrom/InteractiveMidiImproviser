#!/usr/bin/env ruby

require 'yaml'

module Math
  
  class AsymmetricMarkovChain < AsymmetricBidirectionalMarkovChain

    def initialize(order, num_states, num_outcomes)
      super(order, lookahead=1, num_states, num_outcomes)
      @fake_steps_left = lookahead+1
    end
  
    def self.load(filename)
      docs = []
      File.open(filename, 'r') do |f|
        YAML.each_document(f) { |d| docs.push d }
      end
      raise RuntimeError.new("bad markov file") if docs.length != 8

      m = AsymmetricMarkovChain.new(docs[0], docs[2], docs[3])
      m.set_internals(docs[4], docs[5], docs[6], docs[7])

      return m
    end
 
    def observe(outcome)
      super(outcome, @fake_steps_left)
    end
  
    def transition(next_state)
      super(next_state, @fake_steps_left)
    end
  
  end
  
end
