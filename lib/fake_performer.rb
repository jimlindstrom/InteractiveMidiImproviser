#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'

class FakePerformer < Performer
  def initialize
  end

  def perform(event_queue)
    puts "Fake performer:"
    event_queue.each do |e|
      puts "\t#{e.inspect}"
    end
  end
end
