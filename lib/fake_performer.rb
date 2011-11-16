#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'

class FakePerformer
  def perform(event_queue)
    puts "Fake performer:"
    event_queue.each do |e|
      puts "\t#{e.inspect}"
    end
  end
end
