#!/usr/bin/env ruby

require 'yaml'

module Math
  
  # This is just a markov chain where the outcomes are states.  (The more 
  # general, asymmetric one lets the outcomes be something other than states.)
  class MarkovChain < AsymmetricMarkovChain
    def initialize(order, num_states)
      super(order, num_states, num_states)
    end
  end

end
