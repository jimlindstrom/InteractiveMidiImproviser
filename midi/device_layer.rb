#!/usr/bin/env ruby

require 'observer'
require 'portmidi'
require 'midi/clock'

# Refactorings to do:
# 1. Split into Midi::InPort and Midi::OutPort
# 2. Write should take events
# 3. Events should be better parsed.  Don't pass up (or expect in) raw message bytes

module Midi

  class DeviceLayer

    include Observable

    LATENCY_MSEC = 0
  
    def initialize(in_device_num, out_device_num)
      # validate input device number 
      if !is_valid_in_device_num(in_device_num)
        raise ArgumentError, "input device #{in_device_num} is invalid"
      end
      @in_device =  Portmidi::Input.new(in_device_num)
  
      # validate output device number 
      if !is_valid_out_device_num(out_device_num)
        raise ArgumentError, "output device #{out_device_num} is invalid"
      end
      @out_device =  Portmidi::Output.new(out_device_num)
  
      @midi_clock = Midi::Clock.new(LATENCY_MSEC)
      @read_thread = nil
      @logging = false
    end
  
    def is_valid_in_device_num(in_device_num)
      valid_in_device_nums = Portmidi.input_devices.map{ |x| x.device_id }
      return !valid_in_device_nums.index(in_device_num).nil?
    end
  
    def is_valid_out_device_num(out_device_num)
      valid_out_device_nums = Portmidi.output_devices.map{ |x| x.device_id }
      return !valid_out_device_nums.index(out_device_num).nil?
    end

    def set_logging(logging)
      @logging = logging
    end

    def start
      if !@read_thread.nil?
        raise ThreadError, "Attempted to start a thread when already running"
      end

      @read_thread = Thread.new { read_loop }
    end
  
    def stop
      if @read_thread.nil?
        raise ThreadError, "Attempted to stop a thread that wasn't running"
      end

      @stop_flag = true
      @read_thread.join
      @read_thread = nil
    end
  
    def read_loop
      @stop_flag = false
      while @stop_flag == false
        events = @in_device.read(16) # FIXME: what is 16?
        if events
          events.each do |event|
            if !@midi_clock.is_ready?
              @midi_clock.set_timestamp(event[:timestamp])
            end

            puts "{:message => #{event[:message].inspect}, :timestamp => #{event[:timestamp]}" if @logging == true
  
            # puts "notifying my #{count_observers} observers"
            changed
            notify_observers(event)
          end
        end
      end
    end
  
    def write(event)
      # make sure we can calculate the timestamp
      if !@midi_clock.is_ready?
        return
      end
  
      @out_device.write( [ { :message => event, 
                             :timestamp => @midi_clock.get_timestamp } ] )
    end
  
  end
  
end
