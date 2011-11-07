#!/usr/bin/midi

require 'portmidi'

module Midi

  class InPort
    def initialize(port_name)
      selected_port = nil
      Portmidi.input_devices.each do |cur_port|
        if cur_port.name == port_name
          selected_port = cur_port
        end
      end
      raise ArgumentError if selected_port == nil

      @port = Portmidi::Input.new(selected_port.device_id)
    end

    def close
      @port.close
    end

    def blocking_read
      event = nil
      while event.nil?
        raw_events = @port.read
        if raw_events
          raise RuntimeError("Can't handle >1 event yet...") if raw_events.length > 1

          raw_event = raw_events[0]
          case raw_event[:message][0]
          when Midi::Event::NOTE_ON
            event = Midi::Event.new({
                                     :message   => Midi::Event::NOTE_ON,
                                     :pitch     => raw_event[:message][1],
                                     :velocity  => raw_event[:message][2],
                                     :timestamp => raw_event[:timestamp],
                                    })
          when Midi::Event::NOTE_OFF
            event = Midi::Event.new({
                                     :message   => Midi::Event::NOTE_OFF,
                                     :pitch     => raw_event[:message][1],
                                     :velocity  => raw_event[:message][2],
                                     :timestamp => raw_event[:timestamp],
                                    })
          else
            raise RuntimeError("Can't handle event type yet...") if raw_events.length > 1
          end
        end
      end

      return event
    end

  end

end
