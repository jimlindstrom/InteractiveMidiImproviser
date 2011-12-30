#!/usr/bin/env ruby

require 'yaml'

module Math
  
  # This is just a markov chain where the outcomes are states.  (The more 
  # general, asymmetric one lets the outcomes be something other than states.)
  class MarkovChain < AsymmetricMarkovChain
    def initialize(order, num_states)
      super(order, num_states, num_states)
    end
 
    def self.load(filename)
      docs = []
      File.open(filename, 'r') do |f|
        YAML.each_document(f) { |d| docs.push d }
      end
      raise RuntimeError.new("bad markov file") if docs.length != 7

      m = MarkovChain.new(docs[0], docs[2])
      m.set_internals(docs[4], docs[5], docs[6])

      return m
    end

  end

end
