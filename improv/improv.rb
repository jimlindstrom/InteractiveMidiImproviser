#!/usr/bin/env ruby

$LOAD_PATH << '.'
require 'rubymusic_improv'

num_vectors = 250 # there are 409 available
# Training on 250 vectors eats up 840MB
# That's over 3MB / vector

puts "Training..."
i = InteractiveImprovisor.new
i.train num_vectors

puts "Running..."
i.run

