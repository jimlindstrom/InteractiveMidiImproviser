#!/usr/bin/env ruby

require 'thread'
require 'listen/machine'
require 'listen/critics/pitch_critic'

module Listen

	class Listener

		attr_accessor :machine
		
		def initialize
			@device_layer = nil
			@machine = Listen::create_listener_machine(
					lambda { |ev_queue, finished_lambda| 
						self.respond(ev_queue, finished_lambda) 
					}
				)

			@pitch_critic = Listen::Critics::PitchCritic.new
		end
	
		def set_device_layer(device_layer)
			@device_layer = device_layer
		end
	
		# this is called by the state machine after a completed stimulus
		def respond(event_queue, finished_lambda)
			Thread.new do
				make_observation(event_queue)
				response = generate_response
				play_response(response)

				finished_lambda.call
			end
		end
	
		def make_observation(event_queue)
			observation_response = @pitch_critic.make_observation(event_queue)

			# FIXME refactor this into an @ioi_critic
			iois = event_queue.get_interonset_intervals
			puts "\t IOIs: " + iois.inspect
			q_ret = iois.quantize!
			puts "\tqIOIs: " + iois.inspect
			@tempo = q_ret[:q] / 1000.0
			puts "\tTempo: #{@tempo}"
		end
	
		def generate_response
			response_event_queue = Midi::EventQueue.new
			num_notes=5
			num_notes.times do
				# FIXME: pitch critic shouldn't be generating note-on/note-off.  
				# need to rethink the translation layer a bit more.
				resp = @pitch_critic.generate_next_event(response_event_queue)
				if resp.nil?
					puts "got nil next_event"
				else
			    	response_event_queue.enqueue({:message=>[144,resp[:next_state],100],:timestamp=>0})
				end
			end

			puts "response: " + response_event_queue.get_pitches.inspect
			return response_event_queue
		end

		def play_response(response_event_queue)
			# play the response
			response_event_queue.each do |cur_event|
				cur_note=cur_event[:message][1]
				@device_layer.write([144, cur_note, 100])
				puts "sleeping for #{@tempo} sec"
				sleep @tempo*5.0
				@device_layer.write([128, cur_note, 100])
			end

			puts "done."
			puts
		end
	end

end
