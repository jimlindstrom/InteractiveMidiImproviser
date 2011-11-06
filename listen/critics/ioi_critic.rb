#!/usr/bin/env ruby

require 'listen/critics/critic'
require 'markov/chain'

module Listen

  module Critics

    class IOICritic < EventCritic
      MAX_IOI = 30

      def initialize
        @markov_chain = Markov::Chain.new(MAX_IOI)
        @no_observations_made = true
      end

      def observe(event_queue)
        iois = event_queue.get_interonset_intervals
        iois.quantize!
        return nil if iois.empty?

        @no_observations_made = false
        puts "IOICritic:"
        puts "\tobservation: " + iois.inspect
        surprise = @markov_chain.add_observation(iois)
        puts "\tobservation surprise: #{surprise}"
 
        return {:surprise => surprise }
      end

      def generate_next_event(events_queue)
        return nil if @no_observations_made

        iois = events_queue.get_interonset_intervals
        #return nil if iois.empty?
        iois.quantize! if !iois.empty?

        return @markov_chain.generate_next(iois)
      end

      def evaluate_next_event(events_queue, next_event)
        return nil if @no_observations_made

        return nil # not implemented...
        #iois = event_queue.get_interonset_intervals
        #iois.quantize!
        #return @markov_chain.evaluate_next(iois, next_event[:message][2])
      end
    end

  end

end

