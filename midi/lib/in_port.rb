#!/usr/bin/midi

require 'portmidi'

module Midi

  class InPort
    def initialize(port_name, clock)
      @clock = clock
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
        raw_events = @port.read# (16) # 1 messsage == 4 32-bit integers  ?
        if raw_events
          raise RuntimeError.new("Can't handle >1 event yet...") if raw_events.length > 1

          raw_event = raw_events[0]

          if !@clock.is_ready?
            @clock.set_timestamp(raw_event[:timestamp])
          end
          case raw_event[:message][0]
          when Midi::Event::NOTE_ON
            event = Midi::NoteOnEvent.new({
                      :pitch     => raw_event[:message][1],
                      :velocity  => raw_event[:message][2],
                      :timestamp => raw_event[:timestamp],
                    })
          when Midi::Event::NOTE_OFF
            event = Midi::NoteOffEvent.new({
                      :pitch     => raw_event[:message][1],
                      :velocity  => raw_event[:message][2],
                      :timestamp => raw_event[:timestamp],
                    })
          when Midi::Event::META
            case ((raw_event[:message][0]*256) + raw_event[:message][1])
            when Midi::Event::KEY_SIG
              raise RuntimeError.new("parsing error") if raw_event[:message][2] != 2
              event = Midi::KeySigEvent.new({
                        :num_flats => raw_event[:message][3],
                        :is_major  => raw_event[:message][4],
                        :timestamp => raw_event[:timestamp],
                      })
  
            else
              raise RuntimeError.new("Can't handle meta event type yet: #{raw_event.inspect}") 
            end

          else
            raise RuntimeError.new("Can't handle event type yet: #{raw_event.inspect}") 
          end
        end
      end

      return event
    end

    def read_with_timeout(timeout_duration=2.0)
      t0 = Time.now
      while !@port.poll
        sleep (1.0/20.0)
        return nil if (Time.now-t0) > timeout_duration
      end
      return blocking_read
    end

  end

end
