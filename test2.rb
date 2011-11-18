#!/usr/bin/env ruby

$LOAD_PATH << '.'
require 'improvisor'

$LOAD_PATH << "./specs/vectors"
require 'meter_vectors'

key = "Battle hymn of the republic"
puts "detecting meter in '#{key}'"
vector = $meter_vectors[key]
nq = vector[:note_queue]
nq.detect_meter
puts "time sig: #{nq.meter.inspect}"
puts


key = "Bring back my bonnie to me"
puts "detecting meter in '#{key}'"
vector = $meter_vectors[key]
nq = vector[:note_queue]
nq.detect_meter
puts "time sig: #{nq.meter.inspect}"
puts
