#!/usr/bin/env ruby

require 'rubygems'
require 'portmidi'

puts "Input devices:"
Portmidi.input_devices.each do |dev|
  puts "\t%d > %s" % [dev.device_id, dev.name]
end
puts

puts "Output devices:"
Portmidi.output_devices.each do |dev|
  puts "\t%d > %s" % [dev.device_id, dev.name]
end
puts
