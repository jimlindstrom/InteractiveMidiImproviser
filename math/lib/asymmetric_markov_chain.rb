#!/usr/bin/env ruby

require 'yaml'

module Math
  
  class AsymmetricMarkovChain < AsymmetricBidirectionalMarkovChain

    def initialize(order, num_states, num_outcomes)
      super(order, lookahead=1, num_states, num_outcomes)
      @fake_steps_left = lookahead+1
    end
  
    def observe(outcome)
      super(outcome, @fake_steps_left)
    end
  
    def transition(next_state)
      super(next_state, @fake_steps_left)
    end
  
  end
  
end
