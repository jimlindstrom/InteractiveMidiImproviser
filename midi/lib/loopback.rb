#!/usr/bin/env ruby

require 'thread'
require 'pty'

module Midi

  class Loopback

    def self.read_thread; @@read_thread end
    def self.read_thread= v; @@read_thread = v end
     
    def self.create
      Thread.abort_on_exception = true

      max_num_events = 2
      Midi::Loopback::read_thread = self.read_midi_events(max_num_events)
    end

    def self.destroy
      #Midi::Loopback::read_thread.join
      `killall -9 amidi`
      Thread.kill(Midi::Loopback::read_thread)
    end

  private

    def self.read_midi_events(max_num_events)
    
      read_thread = Thread.new do
        num_events = 0
        #cmd = "amidi --port=hw:1,0 --dump --timeout=1"
        cmd = "amidi --port=hw:1,0 --dump"
        IO.popen(cmd) do |stdout|
          stdout.each do |line|
            cmd2 = "amidi --port=hw:1,1 --send-hex=\"#{line.chop}\""
            system(cmd2)
    
            num_events = num_events + 1
            if num_events >= max_num_events
              Thread.current.kill
            end
          end
        end
      end
      
      return read_thread
    end

  end

end
