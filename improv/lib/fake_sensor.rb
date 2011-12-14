#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'

class FakeSensor
  LOGGING = false

  def initialize(vectors)
    @vectors = vectors
    @vector_keys = @vectors.keys
  end

  def get_stimulus
    return nil if @vector_keys.empty?
    next_vector_key = @vector_keys.shift
    puts "FakeSensor returning \"#{next_vector_key}\"" if LOGGING
    vector = @vectors[next_vector_key]

    event_queue = Midi::EventQueue.new
    vector[:events].each do |e|
      event_queue.enqueue e
    end
    return event_queue
  end
end
