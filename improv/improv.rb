#!/usr/bin/env ruby

$LOAD_PATH << '.'
require 'rubymusic_improv'

num_training_vectors = 100 # there are 409 available
num_testing_vectors  =  20
# Training on 250 vectors eats up 840MB
# That's over 3MB / vector

puts "Training..."
i = InteractiveImprovisor.new

surprises = i.train(num_training_vectors, num_testing_vectors)
surprises.each do |s|
  puts "\t#{s[:critic].class}: #{s[:cum_surprise]}"
end
i.save("data/production")

puts "Running..."
i.run

