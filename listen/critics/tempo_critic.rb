#!/usr/bin/env ruby

require 'listen/critics/critic'

module Listen

  module Critics

    class TempoCritic < EventQueueCritic

      def initialize
        @observations = []
      end

      def observe(event_queue)
        iois = event_queue.get_interonset_intervals
        q_ret = iois.quantize!
        tempo = q_ret[:q] / 1000.0

        @observations.push tempo
      end

      def generate
        { :choice => @observations[rand(@observations.size)], 
          :surprise => nil } # no surprise yet
      end

      def evaluate(choice)
        { :surprise => nil }
      end
    end

  end

end

