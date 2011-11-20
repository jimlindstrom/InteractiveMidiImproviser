#!/usr/bin/env ruby

$LOAD_PATH << '.'
require 'improvisor'

$LOAD_PATH << "./specs/vectors"
require 'meter_vectors'

def do_auto_correl(key, expected, marker_idx)
  vector = $meter_vectors[key]
  nq = vector[:note_queue]
  beat_arr = nq.beat_array
  bsm = BeatSimilarityMatrix.new(beat_arr)
  bsm.save(key, expected, marker_idx)
end

key = "Bring back my bonnie to me"
do_auto_correl(key, "[3, 4], 1, 2", 3)
  
key = "Battle hymn of the republic"
do_auto_correl(key, "[4, 4], 4, 15", 16)

key = "Bach Minuet in G"
do_auto_correl(key, "[3, 4], 2, 0", 6)

key = "Somewhere over the rainbow"
do_auto_correl(key, "[4, 4], 2, 0", 8)
