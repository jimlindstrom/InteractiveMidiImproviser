#!/usr/bin/env ruby

module Listen

  module Critics

    class EventCritic
      def initialize
        raise RuntimeError.new("cannot instantiate EventCritic - it's abstract")
      end

      def observe(events)
        # should return nothing
      end

      def generate_next_event(events)
        # should return { :next_event => ?, :surprise => ? }
      end

      def evaluate_next_event(events, next_event)
        # should return { :next_event => ?, :surprise => ? }
      end
    end

    class EventQueueCritic
      def initialize
        raise RuntimeError.new("cannot instantiate EventQueueCritic - it's abstract")
      end

      def observe(events)
        # should return nothing
      end

      def generate
        # should return { :choice => ?, :surprise => ? }
      end

      def evaluate(choice)
        # should return { :surprise => ? }
      end
    end

  end

end

