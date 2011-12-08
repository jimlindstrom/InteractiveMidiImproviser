#!/usr/bin/env ruby

require 'midilib'
require 'midilib/io/seqreader'

# Create a new, empty sequence.
seq = MIDI::Sequence.new()

# Read the contents of a MIDI file into the sequence.
File.open(ARGV[0], 'rb') do |file|
  #puts "reading file #{file}"
  seq.read(file) do |num_tracks, i|
    #puts "read track #{i} of #{num_tracks}"
  end
end

puts "\t\"File: #{ARGV[0]}\" =>"
puts "\t{"
puts "\t\t:events =>"
puts "\t\t["

seq.tracks[1].events.each do |e|
  timestamp = e.time_from_start
  if e.respond_to?(:off)
    pitch    = e.note
    velocity = e.velocity
    puts "\t\t\tMidi::Event.new({:message => 144, :pitch => #{pitch}, :velocity => #{velocity}, :timestamp => #{timestamp}}),"
  elsif e.respond_to?(:on)
    pitch    = e.note
    velocity = e.velocity
    puts "\t\t\tMidi::Event.new({:message => 128, :pitch => #{pitch}, :velocity => #{velocity}, :timestamp => #{timestamp}}),"
  end
end


puts "\t\t],"
puts "\t},"
