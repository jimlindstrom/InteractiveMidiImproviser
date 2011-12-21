#!/usr/bin/env ruby

require 'yaml'

module Math
  
  class BidirectionalMarkovChain < AsymmetricBidirectionalMarkovChain
    def initialize(order, lookahead, num_states)
      super(order, lookahead, num_states, num_outcomes=num_states)
    end
  end
   
end
