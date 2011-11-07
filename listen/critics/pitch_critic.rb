#!/usr/bin/env ruby

require 'listen/critics/critic'
require 'markov/chain'

module Listen

  module Critics

    class PitchTranscoder
      NUM_MIDI_PITCHES = 128

      def self.num_symbols
        return NUM_MIDI_PITCHES
      end

      def self.pitch_to_symbol(p)
        return p
      end

      def self.pitches_to_symbols(ps)
        ps.map{ |p| self.pitch_to_symbol(p) }
      end

      def self.symbol_to_pitch(s)
        return s
      end

      def self.symbols_to_pitches(ss)
        ss.map{ |s| self.symbol_to_pitch(s) }
      end
    end

    class PitchCritic < EventCritic

      def initialize
        @markov_chain = Markov::Chain.new(PitchTranscoder.num_symbols)
        @no_observations_made = true
      end

      def observe(event_queue)
        # should return nothing

        @no_observations_made = false
        pitches = event_queue.get_pitches
        symbols = PitchTranscoder.pitches_to_symbols(pitches)
        surprise = @markov_chain.add_observation(symbols)
  
        puts "PitchCritic:"
        puts "\tobservation: " + pitches.inspect
        puts "\tobservation surprise: #{surprise}"

        return {:surprise => surprise }
      end

      def generate_next_event(events_queue)
        return nil if @no_observations_made

        pitches = events_queue.get_pitches
        symbols = PitchTranscoder.pitches_to_symbols(pitches)
        symbol = @markov_chain.generate_next(symbols)
        return PitchTranscoder.symbol_to_pitch(symbol)
      end

      def evaluate_next_event(events_queue, next_event)
        return nil if @no_observations_made

        pitches = events_queue.get_pitches
        symbols = PitchTranscoder.pitches_to_symbols(pitches)
        return @markov_chain.evaluate_next(symbols, PitchTranscoder.pitch_to_symbol(next_event[:message][1]))
      end

      def possible_next_states(event_queue)
        pitches = event_queue.get_pitches
        symbols = PitchTranscoder.pitches_to_symbols(pitches)
        pns = @markov_chain.possible_next_states(symbols)
        pns[:possible_next_states].map!{ |x| { :next_state => PitchTranscoder.symbol_to_pitch(x[:next_state]), 
                                               :num_observations => x[:num_observations] } }

        return pns
      end
    end

  end

end

