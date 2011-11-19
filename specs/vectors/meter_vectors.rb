$meter_vectors = {}

###############################################################################
# My Bonnie Lies Over The Ocean
###############################################################################

nq = NoteQueue.new
nq.tempo = 100
3.times do
  nq.push Note.new(Pitch.new(1), Duration.new(1)) # my
  
  nq.push Note.new(Pitch.new(2), Duration.new(1)) # bon-
  nq.push Note.new(Pitch.new(3), Duration.new(1)) # -nie
  nq.push Note.new(Pitch.new(3), Duration.new(1)) # lies
  
  nq.push Note.new(Pitch.new(2), Duration.new(1)) # o-
  nq.push Note.new(Pitch.new(3), Duration.new(1)) # -ver
  nq.push Note.new(Pitch.new(3), Duration.new(1)) # the
  
  nq.push Note.new(Pitch.new(2), Duration.new(1)) # o-
  nq.push Note.new(Pitch.new(3), Duration.new(4)) # -cean
end

nq.push Note.new(Pitch.new(1), Duration.new(1)) # so
  
nq.push Note.new(Pitch.new(2), Duration.new(1)) # bring
nq.push Note.new(Pitch.new(3), Duration.new(1)) # back
nq.push Note.new(Pitch.new(3), Duration.new(1)) # my

nq.push Note.new(Pitch.new(2), Duration.new(1)) # bon-
nq.push Note.new(Pitch.new(3), Duration.new(1)) # -nie
nq.push Note.new(Pitch.new(3), Duration.new(1)) # to

nq.push Note.new(Pitch.new(2), Duration.new(6)) # me

2.times do
  nq.push Note.new(Pitch.new(1), Duration.new(3)) # bring
  
  nq.push Note.new(Pitch.new(1), Duration.new(3)) # back
  
  nq.push Note.new(Pitch.new(1), Duration.new(3)) # bring
  
  nq.push Note.new(Pitch.new(1), Duration.new(2)) # back
  nq.push Note.new(Pitch.new(1), Duration.new(1)) # oh
  
  nq.push Note.new(Pitch.new(1), Duration.new(1)) # bring
  nq.push Note.new(Pitch.new(1), Duration.new(1)) # back
  nq.push Note.new(Pitch.new(1), Duration.new(1)) # my
  
  nq.push Note.new(Pitch.new(1), Duration.new(1)) # bon-
  nq.push Note.new(Pitch.new(1), Duration.new(1)) # -nie
  nq.push Note.new(Pitch.new(1), Duration.new(1)) # to
  
  nq.push Note.new(Pitch.new(1), Duration.new(3)) # me
end

$meter_vectors["Bring back my bonnie to me"] =
  {
    :time_sig   => [3, 4], # 3 beats per measure, quarter note tactus
    :multiplier => 1, # durations are expressed in the meter's tactus
    :offset     => 2, # 0 based (meaning beat 3 of 3)
    :note_queue => nq
  }



###############################################################################
# Battle Hymn of the Republic
###############################################################################

nq = NoteQueue.new
nq.tempo = 100

nq.push Note.new(Pitch.new(1), Duration.new(1)) # mine

nq.push Note.new(Pitch.new(2), Duration.new(3)) # eyes
nq.push Note.new(Pitch.new(3), Duration.new(1)) # have
nq.push Note.new(Pitch.new(2), Duration.new(3)) # seen
nq.push Note.new(Pitch.new(3), Duration.new(1)) # the
nq.push Note.new(Pitch.new(2), Duration.new(2)) # glo-
nq.push Note.new(Pitch.new(3), Duration.new(2)) # -ry
nq.push Note.new(Pitch.new(2), Duration.new(2)) # of
nq.push Note.new(Pitch.new(3), Duration.new(2)) # the

nq.push Note.new(Pitch.new(2), Duration.new(3)) # com-
nq.push Note.new(Pitch.new(3), Duration.new(1)) # -ing
nq.push Note.new(Pitch.new(2), Duration.new(3)) # of
nq.push Note.new(Pitch.new(3), Duration.new(1)) # the
nq.push Note.new(Pitch.new(2), Duration.new(4)) # lord;
nq.push Note.new(Pitch.new(2), Duration.new(2)) # he
nq.push Note.new(Pitch.new(3), Duration.new(2)) # is

nq.push Note.new(Pitch.new(2), Duration.new(3)) # tramp-
nq.push Note.new(Pitch.new(3), Duration.new(1)) # -ling
nq.push Note.new(Pitch.new(2), Duration.new(3)) # out
nq.push Note.new(Pitch.new(3), Duration.new(1)) # the
nq.push Note.new(Pitch.new(2), Duration.new(3)) # vint-
nq.push Note.new(Pitch.new(3), Duration.new(1)) # -age
nq.push Note.new(Pitch.new(2), Duration.new(3)) # where
nq.push Note.new(Pitch.new(3), Duration.new(1)) # the

nq.push Note.new(Pitch.new(2), Duration.new(3)) # grapes
nq.push Note.new(Pitch.new(3), Duration.new(1)) # of
nq.push Note.new(Pitch.new(2), Duration.new(3)) # wrath
nq.push Note.new(Pitch.new(3), Duration.new(1)) # are
nq.push Note.new(Pitch.new(2), Duration.new(4)) # stor'd;
nq.push Note.new(Pitch.new(2), Duration.new(2)) # he
nq.push Note.new(Pitch.new(3), Duration.new(2)) # hath

nq.push Note.new(Pitch.new(2), Duration.new(3)) # loosed
nq.push Note.new(Pitch.new(3), Duration.new(1)) # the
nq.push Note.new(Pitch.new(2), Duration.new(3)) # fate-
nq.push Note.new(Pitch.new(3), Duration.new(1)) # -ful
nq.push Note.new(Pitch.new(2), Duration.new(2)) # light-
nq.push Note.new(Pitch.new(3), Duration.new(2)) # -ning
nq.push Note.new(Pitch.new(2), Duration.new(2)) # of
nq.push Note.new(Pitch.new(3), Duration.new(2)) # his

nq.push Note.new(Pitch.new(2), Duration.new(3)) # ter-
nq.push Note.new(Pitch.new(3), Duration.new(1)) # -ri-
nq.push Note.new(Pitch.new(2), Duration.new(3)) # -ble
nq.push Note.new(Pitch.new(3), Duration.new(1)) # swift
nq.push Note.new(Pitch.new(2), Duration.new(4)) # sword;
nq.push Note.new(Pitch.new(2), Duration.new(4)) # his

nq.push Note.new(Pitch.new(2), Duration.new(4)) # truth
nq.push Note.new(Pitch.new(2), Duration.new(4)) # is
nq.push Note.new(Pitch.new(2), Duration.new(4)) # march-
nq.push Note.new(Pitch.new(2), Duration.new(4)) # -ing

nq.push Note.new(Pitch.new(2), Duration.new(16)) # on

$meter_vectors["Battle hymn of the republic"] =
  {
    :time_sig   => [4, 4], # 4 beats per measure, quarter note tactus
    :multiplier => 4, # durations are expressed in 16th notes
    :offset     => 15, # 0 based (the last 16th note of the measure)
    :note_queue => nq
  }


###############################################################################
# Bach - Minuet in G
###############################################################################

nq = NoteQueue.new
nq.tempo = 100

2.times do 
  nq.push Note.new(Pitch.new(1), Duration.new(2)) 
  nq.push Note.new(Pitch.new(2), Duration.new(1)) 
  nq.push Note.new(Pitch.new(3), Duration.new(1)) 
  nq.push Note.new(Pitch.new(3), Duration.new(1)) 
  nq.push Note.new(Pitch.new(3), Duration.new(1)) 
  
  nq.push Note.new(Pitch.new(2), Duration.new(2)) 
  nq.push Note.new(Pitch.new(3), Duration.new(2)) 
  nq.push Note.new(Pitch.new(3), Duration.new(2)) 
end

3.times do 
  nq.push Note.new(Pitch.new(1), Duration.new(2)) 
  nq.push Note.new(Pitch.new(2), Duration.new(1)) 
  nq.push Note.new(Pitch.new(3), Duration.new(1)) 
  nq.push Note.new(Pitch.new(3), Duration.new(1)) 
  nq.push Note.new(Pitch.new(3), Duration.new(1)) 
end

nq.push Note.new(Pitch.new(3), Duration.new(6)) 

$meter_vectors["Bach Minuet in G"] =
  {
    :time_sig   => [3, 4], # 4 beats per measure, quarter note tactus
    :multiplier => 2, # durations are expressed in 16th notes
    :offset     => 0, # 0 based (the first 16th note of the measure)
    :note_queue => nq
  }



###############################################################################
# Somewhere over the rainbow
###############################################################################

nq = NoteQueue.new
nq.tempo = 100

nq.push Note.new(Pitch.new(1), Duration.new(4)) # some-
nq.push Note.new(Pitch.new(2), Duration.new(4)) # -where

nq.push Note.new(Pitch.new(3), Duration.new(2)) # ov-
nq.push Note.new(Pitch.new(3), Duration.new(1)) # -er
nq.push Note.new(Pitch.new(3), Duration.new(1)) # the
nq.push Note.new(Pitch.new(2), Duration.new(2)) # rain-
nq.push Note.new(Pitch.new(3), Duration.new(2)) # -bow

nq.push Note.new(Pitch.new(1), Duration.new(4)) # way
nq.push Note.new(Pitch.new(2), Duration.new(4)) # up

nq.push Note.new(Pitch.new(2), Duration.new(8)) # high

nq.push Note.new(Pitch.new(1), Duration.new(4)) # there's
nq.push Note.new(Pitch.new(2), Duration.new(4)) # a

nq.push Note.new(Pitch.new(3), Duration.new(2)) # land
nq.push Note.new(Pitch.new(3), Duration.new(1)) # that
nq.push Note.new(Pitch.new(3), Duration.new(1)) # I
nq.push Note.new(Pitch.new(2), Duration.new(2)) # heard
nq.push Note.new(Pitch.new(3), Duration.new(2)) # of

nq.push Note.new(Pitch.new(3), Duration.new(2)) # once
nq.push Note.new(Pitch.new(3), Duration.new(1)) # in
nq.push Note.new(Pitch.new(3), Duration.new(1)) # a
nq.push Note.new(Pitch.new(2), Duration.new(2)) # lu-
nq.push Note.new(Pitch.new(3), Duration.new(2)) # -la-

nq.push Note.new(Pitch.new(3), Duration.new(8)) # -by

$meter_vectors["Somewhere over the rainbow"] =
  {
    :time_sig   => [4, 4], # 4 beats per measure, quarter note tactus
    :multiplier => 2, # durations are expressed in 8th notes
    :offset     => 0, # 0 based (first 8th note of measure)
    :note_queue => nq
  }


