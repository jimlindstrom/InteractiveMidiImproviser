#!/usr/bin/env ruby

require 'thread'
require 'pty'

def read_midi_events(max_num_events)

	read_thread = Thread.new do
		num_events = 0
		cmd = "amidi --port=hw:1,0 --dump"
		IO.popen(cmd) do |stdout|
			stdout.each do |line|
				cmd2 = "amidi --port=hw:1,1 --send-hex=\"#{line.chop}\""
				system(cmd2)

				num_events = num_events + 1
				if num_events >= max_num_events
					#exit
				end
			end
		end
	end
	
	return read_thread
end

max_num_events = 2
read_thread = read_midi_events(max_num_events)
read_thread.join
