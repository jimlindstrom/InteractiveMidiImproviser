#!/usr/bin/env ruby

$LOAD_PATH << '.'
require 'rubymusic_improv'

puts "Training..."
i = InteractiveImprovisor.new
i.train

puts "Running..."
i.run

