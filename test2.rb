#!/usr/bin/env ruby

$LOAD_PATH << '.'
require 'improvisor'

$LOAD_PATH << "./specs/vectors"
require 'meter_vectors'

def calc_score(logging)
  score =  0.0
  
  key = "Battle hymn of the republic"
  puts "  detecting meter in '#{key}'" if logging
  vector = $meter_vectors[key]
  nq = vector[:note_queue]
  nq.detect_meter
  if nq.meter[:time_sig] == [4, 4] and nq.meter[:multiplier] == 4 and nq.meter[:offset] == 15
    score += nq.meter[:confidence]-1.0
  else
    score -= nq.meter[:confidence]-1.0
  end
  puts "    expected: " + {:time_sig=>[4, 4], :multiplier=>4, :weights=>[4, 1, 2, 1], :offset=>15}.inspect if logging
  puts "    got:      #{nq.meter.inspect}" if logging
  puts if logging
  
  
  key = "Bring back my bonnie to me"
  puts "  detecting meter in '#{key}'" if logging
  vector = $meter_vectors[key]
  nq = vector[:note_queue]
  nq.detect_meter
  if nq.meter[:time_sig] == [3, 4] and nq.meter[:multiplier] == 1 and nq.meter[:offset] == 2
    score += nq.meter[:confidence]-1.0
  else
    score -= nq.meter[:confidence]-1.0
  end
  puts "    expected: " + {:time_sig=>[3, 4], :multiplier=>1, :weights=>[3, 1, 1], :offset=>2}.inspect if logging
  puts "    got:      #{nq.meter.inspect}" if logging
  puts if logging
  
  
  key = "Bach Minuet in G"
  puts "  detecting meter in '#{key}'" if logging
  vector = $meter_vectors[key]
  nq = vector[:note_queue]
  nq.detect_meter
  if nq.meter[:time_sig] == [3, 4] and nq.meter[:multiplier] == 2 and nq.meter[:offset] == 0
    score += nq.meter[:confidence]-1.0
  else
    score -= nq.meter[:confidence]-1.0
  end
  puts "    expected: " + {:time_sig=>[3, 4], :multiplier=>2, :weights=>[3, 1, 1], :offset=>0}.inspect if logging
  puts "    got:      #{nq.meter.inspect}" if logging
  puts if logging
  
  
  key = "Somewhere over the rainbow"
  puts "  detecting meter in '#{key}'" if logging
  vector = $meter_vectors[key]
  nq = vector[:note_queue]
  nq.detect_meter
  if nq.meter[:time_sig] == [4, 4] and nq.meter[:multiplier] == 2 and nq.meter[:offset] == 0
    score += nq.meter[:confidence]-1.0
  else
    score -= nq.meter[:confidence]-1.0
  end
  puts "    expected: " + {:time_sig=>[4, 4], :multiplier=>2, :weights=>[4, 1, 2, 1], :offset=>0}.inspect if logging
  puts "    got:      #{nq.meter.inspect}" if logging
  puts if logging
  
  puts "  score: #{score}" if logging

  return score
end

# generate population
population = []
20.times do 
  population.push({ :params => MeterDetectorParams.new_random })
end

100.times do |iter_idx|
  # score the population
  population.each do |cur|
    $meter_detector_params = cur[:params]
    cur[:score] = calc_score(false)
  end
  population.sort! { |x,y| y[:score] <=> x[:score] }
  puts "#{iter_idx}: #{population.map{|x| (x[:score]*1000.0).to_i/1000.0 }.inspect}"
  
  # recombine
  (10..16).each do |idx|
    idx1 = (rand*rand*19.0).round
    idx2 = (rand*rand*19.0).round
    population[idx][:params] = MeterDetectorParams.merge(population[idx1][:params], population[idx2][:params])
  end
  (17..19).each do |idx|
    idx1 = (rand*rand*19.0).round
    population[idx][:params] = MeterDetectorParams.merge(population[idx1][:params], MeterDetectorParams.new_random)
  end

end

# print out the best result
$meter_detector_params = population.first[:params]
calc_score(true)
puts "params: " + $meter_detector_params.inspect
