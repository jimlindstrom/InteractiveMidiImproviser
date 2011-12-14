$meter_vectors = {}

###############################################################################
# Music::Notes
###############################################################################

PA3  = 57
PB3  = 59

PC4  = 60
PCs4 = 61
PD4  = 62
PDs4 = 63
PE4  = 64
PF4  = 65
PFs4 = 66
PG4  = 67
PGs4 = 68
PA4  = 69
PB4  = 71

PC5  = 72
PCs5 = 73
PD5  = 74
PE5  = 76
PFs5 = 78
PG5  = 79

###############################################################################
# My Bonnie Lies Over The Ocean
###############################################################################

nq = Music::NoteQueue.new
nq.tempo = 100

nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(1)) # my

nq.push Music::Note.new(Music::Pitch.new(PE5), Music::Duration.new(1)) # bon-
nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(1)) # -nie
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(1)) # lies

nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(1)) # o-
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(1)) # -ver
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(1)) # the

nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(1)) # o-
nq.push Music::Note.new(Music::Pitch.new(PE4), Music::Duration.new(4)) # -cean
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(1)) # my

nq.push Music::Note.new(Music::Pitch.new(PE5), Music::Duration.new(1)) # bon-
nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(1)) # -nie
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(1)) # lies

nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(1)) # o-
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) # -ver
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(1)) # the

nq.push Music::Note.new(Music::Pitch.new(PD4), Music::Duration.new(5)) # sea

nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(1)) # my

nq.push Music::Note.new(Music::Pitch.new(PE5), Music::Duration.new(1)) # bon-
nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(1)) # -nie
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(1)) # lies

nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(1)) # o-
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(1)) # -ver
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(1)) # the

nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(1)) # o-
nq.push Music::Note.new(Music::Pitch.new(PE4), Music::Duration.new(4)) # -cean
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(1)) # so
  
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(1)) # bring
nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(1)) # back
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(1)) # my

nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) # bon-
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(1)) # -nie
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) # to

nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(6)) # me

nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(3)) # bring

nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(3)) # back

nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(3)) # bring

nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(2)) # back
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(1)) # oh

nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) # bring
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) # back
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) # my
  
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) # bon-
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(1)) # -nie
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) # to
  
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(2)) # me,
nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(1)) # to
nq.push Music::Note.new(Music::Pitch.new(PE5), Music::Duration.new(3)) # me

nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(3)) # bring

nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(3)) # back

nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(3)) # bring

nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(2)) # back
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(1)) # oh

nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) # bring
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) # back
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) # my
  
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) # bon-
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(1)) # -nie
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) # to
  
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(6)) # me

m = Music::Meter.new(3, 4, 1) # 3/4 time, quarter note pulses
b = Music::BeatPosition.new
b.measure     = 0
b.beat        = 2 # 0-based: beat 3 
b.subbeat     = 0 # 0-based: first subbeatision
b.beats_per_measure = 3 # 0-based: beat 3 
b.subbeats_per_beat = 1 # 0-based: first subbeatision
$meter_vectors["Bring back my bonnie to me"] =
  {
    :meter               => m,
    :first_beat_position => b,
    :note_queue          => nq
  }



###############################################################################
# Battle Hymn of the Republic
###############################################################################

nq = Music::NoteQueue.new
nq.tempo = 100

nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(1)) # mine

nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(3)) # eyes
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(1)) # have
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(3)) # seen
nq.push Music::Note.new(Music::Pitch.new(PF4), Music::Duration.new(1)) # the
nq.push Music::Note.new(Music::Pitch.new(PE4), Music::Duration.new(2)) # glo-
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(2)) # -ry
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(2)) # of
nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(2)) # the

nq.push Music::Note.new(Music::Pitch.new(PE5), Music::Duration.new(3)) # com-
nq.push Music::Note.new(Music::Pitch.new(PE5), Music::Duration.new(1)) # -ing
nq.push Music::Note.new(Music::Pitch.new(PE5), Music::Duration.new(3)) # of
nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(1)) # the
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(4)) # lord;
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(2)) # he
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(2)) # is

nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(3)) # tramp-
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(1)) # -ling
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(3)) # out
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) # the
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(3)) # vint-
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) # -age
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(3)) # where
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(1)) # the

nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(3)) # grapes
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(1)) # of
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(3)) # wrath
nq.push Music::Note.new(Music::Pitch.new(PE4), Music::Duration.new(1)) # are
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(4)) # stor'd;
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(2)) # he
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(2)) # hath

nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(3)) # loosed
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(1)) # the
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(3)) # fate-
nq.push Music::Note.new(Music::Pitch.new(PF4), Music::Duration.new(1)) # -ful
nq.push Music::Note.new(Music::Pitch.new(PE4), Music::Duration.new(2)) # light-
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(2)) # -ning
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(2)) # of
nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(2)) # his

nq.push Music::Note.new(Music::Pitch.new(PE5), Music::Duration.new(3)) # ter-
nq.push Music::Note.new(Music::Pitch.new(PE5), Music::Duration.new(1)) # -ri-
nq.push Music::Note.new(Music::Pitch.new(PE5), Music::Duration.new(3)) # -ble
nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(1)) # swift
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(4)) # sword;
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(4)) # his

nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(4)) # truth
nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(4)) # is
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(4)) # march-
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(4)) # -ing

nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(16)) # on


m = Music::Meter.new(4, 4, 4) # 4/4 time, sixteenth note pulses
b = Music::BeatPosition.new
b.measure     = 0
b.beat        = 3 # 0-based: beat 4 
b.subbeat     = 3 # 0-based: last subbeatision
b.beats_per_measure = 4 # 4 beats
b.subbeats_per_beat = 4 # 4th of quarter notes

$meter_vectors["Battle hymn of the republic"] =
  {
    :meter               => m,
    :first_beat_position => b,
    :note_queue          => nq
  }


###############################################################################
# Bach - Minuet in G
###############################################################################

nq = Music::NoteQueue.new
nq.tempo = 100

nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(2)) 
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(1)) 
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(1)) 
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) 
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(1)) 
  
nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(2)) 
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(2)) 
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(2)) 

nq.push Music::Note.new(Music::Pitch.new(PE5), Music::Duration.new(2)) 
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(1)) 
nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(1)) 
nq.push Music::Note.new(Music::Pitch.new(PE5), Music::Duration.new(1)) 
nq.push Music::Note.new(Music::Pitch.new(PFs5), Music::Duration.new(1)) 
  
nq.push Music::Note.new(Music::Pitch.new(PG5), Music::Duration.new(2)) 
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(2)) 
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(2)) 

nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(2)) 
nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(1)) 
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(1)) 
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) 
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(1)) 

nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(2)) 
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(1)) 
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) 
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(1)) 
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(1)) 

nq.push Music::Note.new(Music::Pitch.new(PFs4), Music::Duration.new(2)) 
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(1)) 
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(1)) 
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) 
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(1)) 

nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(6)) 

m = Music::Meter.new(3, 4, 2) # 4/4 time, sixteenth note pulses
b = Music::BeatPosition.new
b.measure     = 0
b.beat        = 0 # 0-based: beat 1 
b.subbeat     = 0 # 0-based: first subbeatision
b.beats_per_measure = 3 # 3 beats
b.subbeats_per_beat = 2 # half of quarter notes

$meter_vectors["Bach Minuet in G"] =
  {
    :meter               => m,
    :first_beat_position => b,
    :note_queue          => nq
  }


###############################################################################
# Somewhere over the rainbow
###############################################################################

nq = Music::NoteQueue.new
nq.tempo = 100

nq.push Music::Note.new(Music::Pitch.new(PC4), Music::Duration.new(4)) # some-
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(4)) # -where

nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(2)) # ov-
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(1)) # -er
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(1)) # the
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(2)) # rain-
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(2)) # -bow

nq.push Music::Note.new(Music::Pitch.new(PC4), Music::Duration.new(4)) # way
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(4)) # up

nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(8)) # high

nq.push Music::Note.new(Music::Pitch.new(PA3), Music::Duration.new(4)) # there's
nq.push Music::Note.new(Music::Pitch.new(PF4), Music::Duration.new(4)) # a

nq.push Music::Note.new(Music::Pitch.new(PE4), Music::Duration.new(2)) # land
nq.push Music::Note.new(Music::Pitch.new(PC4), Music::Duration.new(1)) # that
nq.push Music::Note.new(Music::Pitch.new(PD4), Music::Duration.new(1)) # I
nq.push Music::Note.new(Music::Pitch.new(PE4), Music::Duration.new(2)) # heard
nq.push Music::Note.new(Music::Pitch.new(PF4), Music::Duration.new(2)) # of

nq.push Music::Note.new(Music::Pitch.new(PD4), Music::Duration.new(2)) # once
nq.push Music::Note.new(Music::Pitch.new(PB3), Music::Duration.new(1)) # in
nq.push Music::Note.new(Music::Pitch.new(PC4), Music::Duration.new(1)) # a
nq.push Music::Note.new(Music::Pitch.new(PD4), Music::Duration.new(2)) # lu-
nq.push Music::Note.new(Music::Pitch.new(PE4), Music::Duration.new(2)) # -la-

nq.push Music::Note.new(Music::Pitch.new(PC4), Music::Duration.new(8)) # -by

m = Music::Meter.new(4, 4, 2) # 4/4 time, sixteenth note pulses
b = Music::BeatPosition.new
b.measure     = 0
b.beat        = 0 # 0-based: beat 1 
b.subbeat     = 0 # 0-based: first subbeatision
b.beats_per_measure = 4 # 4 beats
b.subbeats_per_beat = 2 # half of quarter notes

$meter_vectors["Somewhere over the rainbow"] =
  {
    :meter               => m,
    :first_beat_position => b,
    :note_queue          => nq
  }


###############################################################################
# This train is bound for glory
###############################################################################

nq = Music::NoteQueue.new
nq.tempo = 100

nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(2)) # this
nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(4)) # train
nq.push Music::Note.new(Music::Pitch.new(PGs4), Music::Duration.new(2)) # is 
nq.push Music::Note.new(Music::Pitch.new(PFs4), Music::Duration.new(3)) # bound
nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(1)) # for
nq.push Music::Note.new(Music::Pitch.new(PCs4), Music::Duration.new(2)) # glo-
nq.push Music::Note.new(Music::Pitch.new(PB3 ), Music::Duration.new(2)) # -ry

nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(2)) # this
nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(14)) # train

nq.push Music::Note.new(Music::Pitch.new(PB4 ), Music::Duration.new(2)) # this
nq.push Music::Note.new(Music::Pitch.new(PB4 ), Music::Duration.new(4)) # train
nq.push Music::Note.new(Music::Pitch.new(PE5 ), Music::Duration.new(2)) # is 
nq.push Music::Note.new(Music::Pitch.new(PCs5), Music::Duration.new(3)) # bound
nq.push Music::Note.new(Music::Pitch.new(PB4 ), Music::Duration.new(1)) # for
nq.push Music::Note.new(Music::Pitch.new(PGs4), Music::Duration.new(2)) # glo-
nq.push Music::Note.new(Music::Pitch.new(PB4 ), Music::Duration.new(2)) # -ry

nq.push Music::Note.new(Music::Pitch.new(PB4 ), Music::Duration.new(2)) # this
nq.push Music::Note.new(Music::Pitch.new(PB4 ), Music::Duration.new(14)) # train

nq.push Music::Note.new(Music::Pitch.new(PB4 ), Music::Duration.new(2)) # this
nq.push Music::Note.new(Music::Pitch.new(PB4 ), Music::Duration.new(4)) # train
nq.push Music::Note.new(Music::Pitch.new(PE5 ), Music::Duration.new(2)) # is 
nq.push Music::Note.new(Music::Pitch.new(PCs5), Music::Duration.new(3)) # bound
nq.push Music::Note.new(Music::Pitch.new(PB4 ), Music::Duration.new(1)) # for
nq.push Music::Note.new(Music::Pitch.new(PGs4), Music::Duration.new(2)) # glo-
nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(2)) # -ry

nq.push Music::Note.new(Music::Pitch.new(PFs4), Music::Duration.new(2)) # don't
nq.push Music::Note.new(Music::Pitch.new(PFs4), Music::Duration.new(2)) # take
nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(1)) # no-
nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(1)) # -thing
nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(1)) # but
nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(1)) # the
nq.push Music::Note.new(Music::Pitch.new(PGs4), Music::Duration.new(1)) # right-
nq.push Music::Note.new(Music::Pitch.new(PGs4), Music::Duration.new(1)) # -eous
nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(1)) # an'
nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(1)) # the
nq.push Music::Note.new(Music::Pitch.new(PCs4), Music::Duration.new(2)) # ho-
nq.push Music::Note.new(Music::Pitch.new(PB3 ), Music::Duration.new(2)) # -ly

nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(2)) # this
nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(4)) # train
nq.push Music::Note.new(Music::Pitch.new(PGs4), Music::Duration.new(2)) # is 
nq.push Music::Note.new(Music::Pitch.new(PFs4), Music::Duration.new(3)) # bound
nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(1)) # for
nq.push Music::Note.new(Music::Pitch.new(PCs4), Music::Duration.new(2)) # glo-
nq.push Music::Note.new(Music::Pitch.new(PB3 ), Music::Duration.new(2)) # -ry

nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(2)) # this
nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(14)) # train

m = Music::Meter.new(4, 4, 4) # 4/4 time, sixteenth note pulses
b = Music::BeatPosition.new
b.measure     = 0
b.beat        = 0 # 0-based: beat 1 
b.subbeat     = 0 # 0-based: first subbeatision
b.beats_per_measure = 4 # 4 beats
b.subbeats_per_beat = 4 # half of quarter notes

$meter_vectors["This train is bound for glory"] =
  {
    :meter               => m,
    :first_beat_position => b,
    :note_queue          => nq
  }


###############################################################################
# Bach Minuet (2)
###############################################################################

nq = Music::NoteQueue.new
nq.tempo = 100

nq.push Music::Note.new(Music::Pitch.new(PD5 ), Music::Duration.new(2)) 
nq.push Music::Note.new(Music::Pitch.new(PD5 ), Music::Duration.new(2))
nq.push Music::Note.new(Music::Pitch.new(PD5 ), Music::Duration.new(2))

nq.push Music::Note.new(Music::Pitch.new(PB4 ), Music::Duration.new(2))
nq.push Music::Note.new(Music::Pitch.new(PA4 ), Music::Duration.new(1))
nq.push Music::Note.new(Music::Pitch.new(PB4 ), Music::Duration.new(1))
nq.push Music::Note.new(Music::Pitch.new(PG4 ), Music::Duration.new(2))

nq.push Music::Note.new(Music::Pitch.new(PA4 ), Music::Duration.new(2)) 
nq.push Music::Note.new(Music::Pitch.new(PD5 ), Music::Duration.new(2))
nq.push Music::Note.new(Music::Pitch.new(PC5 ), Music::Duration.new(2))

nq.push Music::Note.new(Music::Pitch.new(PB4 ), Music::Duration.new(4)) 
nq.push Music::Note.new(Music::Pitch.new(PA4 ), Music::Duration.new(2))

nq.push Music::Note.new(Music::Pitch.new(PD5 ), Music::Duration.new(2))
nq.push Music::Note.new(Music::Pitch.new(PC5 ), Music::Duration.new(1))
nq.push Music::Note.new(Music::Pitch.new(PB4 ), Music::Duration.new(1))
nq.push Music::Note.new(Music::Pitch.new(PA4 ), Music::Duration.new(1))
nq.push Music::Note.new(Music::Pitch.new(PG4 ), Music::Duration.new(1))

nq.push Music::Note.new(Music::Pitch.new(PE5 ), Music::Duration.new(2))
nq.push Music::Note.new(Music::Pitch.new(PC5 ), Music::Duration.new(1))
nq.push Music::Note.new(Music::Pitch.new(PB4 ), Music::Duration.new(1))
nq.push Music::Note.new(Music::Pitch.new(PA4 ), Music::Duration.new(1))
nq.push Music::Note.new(Music::Pitch.new(PG4 ), Music::Duration.new(1))

nq.push Music::Note.new(Music::Pitch.new(PFs4), Music::Duration.new(2))
nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(1))
nq.push Music::Note.new(Music::Pitch.new(PD4 ), Music::Duration.new(1))
nq.push Music::Note.new(Music::Pitch.new(PFs4), Music::Duration.new(2))

nq.push Music::Note.new(Music::Pitch.new(PG4 ), Music::Duration.new(6)) 

m = Music::Meter.new(3, 4, 2) # 3/4 time, eighth note pulses
b = Music::BeatPosition.new
b.measure     = 0
b.beat        = 0 # 0-based: beat 1 
b.subbeat     = 0 # 0-based: first subbeatision
b.beats_per_measure = 3 # 4 beats
b.subbeats_per_beat = 2 # half of quarter notes

$meter_vectors["Bach Minuet (2)"] =
  {
    :meter               => m,
    :first_beat_position => b,
    :note_queue          => nq
  }

