#!/usr/bin/env ruby

$LOAD_PATH << '.'
require 'rubymusic_improv'

do_training = false
num_training_vectors = 300 # there are 409 available
num_testing_vectors  =  20

puts "Training..."
i = InteractiveImprovisor.new

if do_training
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

