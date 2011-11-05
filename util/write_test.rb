#!/usr/bin/env ruby

require 'rubygems'
require 'portmidi'

messages = [
  {:message => [0x90, 0x2D, 0x94], :timestamp => 1},
  {:message => [0x80, 0x2D, 0x94], :timestamp => 2000}
]

Portmidi.output_devices.each do |dev|
  puts "%d > %s" % [dev.device_id, dev.name]
end
puts "choose device id"
device_id = gets()

output =  Portmidi::Output.new(device_id.to_i)
output.write(messages)
