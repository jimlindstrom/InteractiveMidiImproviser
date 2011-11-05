#!/usr/bin/env ruby

module Midi

	class Clock
		def initialize(latency_msec)
			@initial_systime   = nil
			@initial_timestamp = nil
			@latency_msec      = latency_msec
		end
	
		def is_ready?
			return !@initial_timestamp.nil?
		end
	
		def set_timestamp(initial_timestamp)
			@initial_systime   = Time.now
			@initial_timestamp = initial_timestamp
		end
	
		def get_timestamp
			if !is_ready?
				return nil
			end

			elapsed_msec = ((Time.now - @initial_systime) * 1000).round
			cur_timestamp = @initial_timestamp + elapsed_msec + @latency_msec
			return cur_timestamp
		end
	end

end
