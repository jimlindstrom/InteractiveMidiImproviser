#!/usr/bin/env ruby

require 'listen/critics/critic'
require 'markov/chain'

module Listen

  module Critics

    class IntervalTranscoder
      NUM_MIDI_PITCHES = 128

      def self.num_symbols
        return NUM_MIDI_PITCHES*2
      end

      def self.interval_to_symbol(i)
        return i + NUM_MIDI_PITCHES
      end

      def self.intervals_to_symbols(is)
        is.map{ |i| self.interval_to_symbol(i) }
      end

      def self.symbol_to_interval(s)
        return s - NUM_MIDI_PITCHES
      end

      def self.symbols_to_intervals(ss)
        ss.map{ |s| self.symbol_to_interval(s) }
      end
    end

    class IntervalCritic < EventCritic

      def initialize
        @markov_chain = Markov::Chain.new(IntervalTranscoder.num_symbols)
        @no_observations_made = true
      end

      def observe(event_queue)
        # should return nothing

        @no_observations_made = false
        intervals = event_queue.get_pitches.each_cons(2).map{ |x,y| y - x }
        symbols = IntervalTranscoder.intervals_to_symbols(intervals)
        surprise = @markov_chain.add_observation(symbols)
  
        puts "IntervalCritic:"
        puts "\tobservation: " + intervals.inspect
        puts "\tobservation surprise: #{surprise}"

        return {:surprise => surprise }
      end

      def generate_next_event(events_queue)
        return nil if @no_observations_made

        intervals = events_queue.get_pitches.each_cons(2).map{ |x,y| y - x }
        symbols = IntervalTranscoder.intervals_to_symbols(intervals)
        response = @markov_chain.generate_next(symbols)
        response[:next_state] = IntervalTranscoder.symbol_to_interval(response[:next_state])
        return response
      end

      def evaluate_next_event(events_queue, next_event)
        return nil if @no_observations_made

        intervals = event_queue.get_pitches.each_cons(2).map{ |x,y| y - x }
        symbols = IntervalTranscoder.intervals_to_symbols(intervals)
        return @markov_chain.evaluate_next(symbols, IntervalTranscoder.interval_to_symbol(next_event[:message][1]))
      end

      def possible_next_states(event_queue)
        last_pitch = event_queue.get_pitches.last
        intervals = event_queue.get_pitches.each_cons(2).map{ |x,y| y - x }
        symbols = IntervalTranscoder.intervals_to_symbols(intervals)
        pns = @markov_chain.possible_next_states(symbols)
        pns[:possible_next_states].map!{ |x| { :next_state => last_pitch + IntervalTranscoder.symbol_to_interval(x[:next_state]), 
                                               :num_observations => x[:num_observations] } }

        return pns

      end
    end

  end

end

