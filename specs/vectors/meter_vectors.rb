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
    :meter      => [3, 4] # 3 beats per measure, quarter note tactus
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
    :meter      => [4, 4] # 4 beats per measure, quarter note tactus
    :multiplier => 4, # durations are expressed in sixteenth notes
    :offset     => 3, # 0 based (meaning beat 4 of 4)
    :note_queue => nq
  }

