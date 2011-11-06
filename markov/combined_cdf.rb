#!/usr/bin/env ruby

require 'markov/state'

module Markov

  class CombinedCDF < State

    def initialize(num_states)
      super(num_states)
    end

    def add_possible_next_states(next_states)
      next_states[:possible_next_states].each do |x|
        x[:num_observations].times do
          add_observation x[:next_state]
        end
      end
    end

  end
  
end
