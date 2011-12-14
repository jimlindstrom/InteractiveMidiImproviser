#!/usr/bin/env ruby

$LOAD_PATH << '.'
require 'improvisor'

puts "Training..."
i = InteractiveImprovisor.new
i.train

puts "Running..."
i.run

