#!/usr/bin/env ruby

require 'midi/ioi_array'

module Midi

	class EventQueue < Array
		def clear
			while !empty?
				a=pop
			end
		end

		def enqueue(e)
			push(e)
		end

		def get_pitches
			select{|x| x[:message][0]==144 }.map{|x| x[:message][1] }
		end

		def get_interonset_intervals
			return Midi::IOIArray.new( select{|x| x[:message][0]==144 }.map{|x| x[:timestamp] }.each_cons(2).map{ |a,b| b-a } )
		end
	end

end

