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

key = "Bring back my bonnie to me"
do_auto_correl(key, "[3, 4], 1, 2", 3, 2)
  
key = "Battle hymn of the republic"
do_auto_correl(key, "[4, 4], 4, 15", 16, 15)

key = "Bach Minuet in G"
do_auto_correl(key, "[3, 4], 2, 0", 6, 0)

key = "Somewhere over the rainbow"
do_auto_correl(key, "[4, 4], 2, 0", 8, 0)

key = "This train is bound for glory"
do_auto_correl(key, "[4, 4], 4, 0", 16, 0)

key = "Bach Minuet (2)"
do_auto_correl(key, "[3, 4], 2, 0", 6, 0)

key = "Amazing Grace"
do_auto_correl(key, "[3, 4], 2, 0", 6, 0)

key = "Ode to Joy"
do_auto_correl(key, "[4, 4], 2, 0", 8, 0)

