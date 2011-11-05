#!/usr/bin/env ruby

require 'rubygems'
require 'portmidi'

Portmidi.input_devices.each do |dev|
  puts "%d > %s" % [dev.device_id, dev.name]
end
puts "choose device id"
device_id = gets()

input =  Portmidi::Input.new(device_id.to_i)
cnt = 0
data = []
running_sysex = []
sysex_is_on = false
loop do
  begin
    events = input.read(16)
    if events
      events.each do |event|
        
        puts String(event[:timestamp]) + " " + event[:message].inspect

      end
      # data << events
    else
      # puts "poll" if cnt % 10000 == 0
    end
  rescue Portmidi::DeviceError => e
    puts e.portmidi_error
  end
  cnt += 1
  #sleep 0.002
end
