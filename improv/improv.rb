#!/usr/bin/env ruby

$LOAD_PATH << '.'
require 'rubymusic_improv'

do_training = false
num_training_vectors = 600 # there are 1300+ available
num_testing_vectors  =  20

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
    puts "\t#{s[:critic].class}: #{s[:cum_surprise]}"
  end
  i.save "data/production"
else
  i.load "data/production"
end

puts "Running..."
i.run

