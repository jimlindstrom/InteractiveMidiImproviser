#!/usr/bin/env ruby

$LOAD_PATH << '.'
require 'improvisor'

$LOAD_PATH << "./specs/vectors"
require 'meter_vectors'

#vector = $meter_vectors["Battle hymn of the republic"]
vector = $meter_vectors["Bring back my bonnie to me"]
nq = vector[:note_queue]
nq.detect_meter
puts "time sig: #{nq.meter.inspect}"
