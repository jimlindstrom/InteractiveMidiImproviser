#!/usr/bin/env ruby

require 'portmidi'

module Midi

  class OutPort
    def initialize(port_name)
      selected_port = nil
      Portmidi.output_devices.each do |cur_port|
        if cur_port.name == port_name
          selected_port = cur_port
        end
      end
      raise ArgumentError if selected_port == nil

      @port = Portmidi::Output.new(selected_port.device_id)
    end

    def close
      @port.close
    end

    def write(event)
      @port.write( [ { :message => [ event.message, event.pitch, event.velocity, 0 ],
                       :timestamp => event.timestamp } ] )
    end

  end

end
