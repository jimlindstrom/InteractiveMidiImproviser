#!/usr/bin/env ruby

require 'listen/critics/critic'

module Listen

  module Critics

    class PitchCountCritic < EventQueueCritic

      def initialize
        @observations = []
      end

      def observe(event_queue)
        @observations.push event_queue.get_pitches.count
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

