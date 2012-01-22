#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'specs'))

require 'spec_helper'

$phrasing_vectors.keys[0..1].each do |key|
  puts "Detecting #{key}"
  vector = $phrasing_vectors[key]
  nq = vector[:note_queue]
  nq.detect_phrases
end
