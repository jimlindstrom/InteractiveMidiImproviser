#!/usr/bin/env ruby

$LOAD_PATH << '.'
require 'rubymusic_music'

$LOAD_PATH << "./specs/vectors"
require 'meter_vectors'

def do_auto_correl(key, expected, meter_idx, offset_idx)
  vector = $meter_vectors[key]
  nq = vector[:note_queue]
  beat_arr = nq.beat_array
  bsm = Music::BeatSimilarityMatrix.new(beat_arr)
  bsm.save(key, expected, meter_idx, offset_idx)
end

$meter_vectors.keys.sort.each do |key|
  cur_vector = $meter_vectors[key]

  subbeats_per_measure = cur_vector[:meter].beats_per_measure * 
                         cur_vector[:meter].subbeats_per_beat

  initial_subbeat = (cur_vector[:first_beat_position].beat * cur_vector[:meter].subbeats_per_beat) +
                     cur_vector[:first_beat_position].subbeat

  string = "[#{cur_vector[:meter].beats_per_measure}, 4], #{cur_vector[:meter].subbeats_per_beat}, #{initial_subbeat}"
  
  do_auto_correl(key, string, subbeats_per_measure, initial_subbeat)
end
