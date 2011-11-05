#!/usr/bin/env ruby

require 'listen/critics/critic'
require 'markov/chain'

module Listen

	module Critics

		class PitchCritic
			NUM_MIDI_PITCHES = 128

			def initialize
				@markov_chain = Markov::Chain.new(NUM_MIDI_PITCHES)
				@no_observations_made = true
			end

			def make_observation(event_queue)
				# should return nothing

				@no_observations_made = false
				pitches = event_queue.get_pitches
				surprise = @markov_chain.add_observation(pitches)
	
				puts "PitchCritic:"
				puts "\tobservation: " + pitches.inspect
				puts "\tobservation surprise: #{surprise}"

				return {:surprise => surprise }
			end

			def generate_next_event(events_queue)
				return nil if @no_observations_made

				pitches = events_queue.get_pitches
				return @markov_chain.generate_next(pitches)
			end

			def evaluate_next_event(events_queue, next_event)
				return nil if @no_observations_made

				pitches = events_queue.get_pitches
				return @markov_chain.evaluate_next(pitches, next_event[:message][1])
			end
		end

	end

end

