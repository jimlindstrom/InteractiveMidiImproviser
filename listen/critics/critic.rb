#!/usr/bin/env ruby

module Listen

	module Critics

		class Critic
			def initialize
				raise RuntimeError.new("cannot instantiate Critic - it's abstract")
			end

			def make_observation(events)
				# should return nothing
			end

			def generate_next_event(events)
				# should return { :next_event => ?, :surprise => ? }
			end

			def evaluate_next_event(events, next_event)
				# should return { :next_event => ?, :surprise => ? }
			end
		end

	end

end

