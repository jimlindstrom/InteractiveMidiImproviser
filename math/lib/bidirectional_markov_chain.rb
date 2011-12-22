#!/usr/bin/env ruby

require 'yaml'

module Math
  
  class BidirectionalMarkovChain < AsymmetricBidirectionalMarkovChain
    def initialize(order, lookahead, num_states)
      super(order, lookahead, num_states, num_outcomes=num_states)
    end
 
    def self.load(filename)
      docs = []
      File.open(filename, 'r') do |f|
        YAML.each_document(f) { |d| docs.push d }
      end
      raise RuntimeError.new("bad markov file") if docs.length != 8

      m = BidirectionalMarkovChain.new(docs[0], docs[1], docs[2])
      m.set_internals(docs[4], docs[5], docs[6], docs[7])

      return m
    end

  end
   
end
