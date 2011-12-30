#!/usr/bin/env ruby

$LOAD_PATH << '.'
require 'rubymusic_improv'

do_training = false
num_training_vectors = 400 # there are 1300+ available
num_testing_vectors  =  20

# Last best run:
#   PitchCritic:                   3710.243064776054
#   IntervalCritic:                4698.001156797827
#   PitchAndPitchClassSetCritic:   5397.955312380645 # uses backoff scaling (had been 11950 before backoff scaling)
#   DurationCritic:                3069.602244765782
#   DurationAndBeatPositionCritic: 2976.034956725619 # uses backoff scaling (had been 3069 before backoff scaling)

if ARGV.length > 0
  case ARGV[0].upcase
  when "TRAIN"
    do_training = true
  else
    puts "usage: ./improv [train]"
    puts "  if you specify 'train', improv will do training.  The default is to load stored training data."
    exit
  end
end

i = InteractiveImprovisor.new

if do_training
  puts "Training..."
  surprises = i.train(num_training_vectors, num_testing_vectors)
  surprises.each do |s|
    puts "\t#{s[:critic].class}: #{s[:cum_information_content]}"
  end
  i.save "data/production"
else
  puts "Loading..."
  i.load "data/production"
end

puts "Running..."
i.run

