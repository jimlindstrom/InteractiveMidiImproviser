#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'

class MidiPerformer < Performer
  def initialize(port_name)
    @outport = Midi::OutPort.new(port_name)
  end

  def close
    @outport.close
    @outport = nil
  end

  def perform(event_queue)
    last_timestamp = event_queue.first.timestamp
    event_queue.each do |e|
      if e.timestamp > last_timestamp
        t = (e.timestamp - last_timestamp)/1000.0
        puts "sleeping for #{t}"
        sleep t
        last_timestamp = e.timestamp
      end

      puts "writing event"
      @outport.write(e)
    end
  end

end
