#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'

class FakeSensor
  def initialize(vectors)
    @vectors = vectors
    @vector_keys = @vectors.keys
  end

  def get_stimulus
    return nil if @vector_keys.empty?
    vector = @vectors[@vector_keys.shift]

    event_queue = Midi::EventQueue.new
    vector[:events].each do |e|
      event_queue.enqueue e
    end
    return event_queue
  end
end
