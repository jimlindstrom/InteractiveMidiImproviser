$meter_vectors = {}
$phrasing_vectors = {}

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

nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(1)) # my			0		++

nq.push Music::Note.new(Music::Pitch.new(PE5), Music::Duration.new(1)) # bon-		1
nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(1)) # -nie		2
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(1)) # lies		3

nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(1)) # o-			4	
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(1)) # -ver		5
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(1)) # the		6

nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(1)) # o-			7
nq.push Music::Note.new(Music::Pitch.new(PE4), Music::Duration.new(4)) # -cean		8		--
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(1)) # my			9		++

nq.push Music::Note.new(Music::Pitch.new(PE5), Music::Duration.new(1)) # bon-		10
nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(1)) # -nie		11
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(1)) # lies		12

nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(1)) # o-			13
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) # -ver		14
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(1)) # the		15

nq.push Music::Note.new(Music::Pitch.new(PD4), Music::Duration.new(5)) # sea		16		--

nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(1)) # my			17		++

nq.push Music::Note.new(Music::Pitch.new(PE5), Music::Duration.new(1)) # bon-		18
nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(1)) # -nie		19
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(1)) # lies		20

nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(1)) # o-			21
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(1)) # -ver		22
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(1)) # the		23

nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(1)) # o-			24
nq.push Music::Note.new(Music::Pitch.new(PE4), Music::Duration.new(4)) # -cean		25		--
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(1)) # so			26		++
  
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(1)) # bring		27
nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(1)) # back		28
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(1)) # my			29

nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) # bon-		30
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(1)) # -nie		31
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) # to			32

nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(6)) # me			33		--

nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(3)) # bring		34		++

nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(3)) # back		35

nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(3)) # bring		36

nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(2)) # back		37		--
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(1)) # oh			38		++

nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) # bring		39
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) # back		40
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) # my			41
  
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) # bon-		42
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(1)) # -nie		43
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) # to			44
  
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(2)) # me,		45
nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(1)) # to			46
nq.push Music::Note.new(Music::Pitch.new(PE5), Music::Duration.new(3)) # me			47		--

nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(3)) # bring		48		++

nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(3)) # back		49

nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(3)) # bring		50

nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(2)) # back		51		--
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(1)) # oh			52		++

nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) # bring		53
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) # back		54
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) # my			55
  
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) # bon-		56
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(1)) # -nie		57
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) # to			58
  
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(6)) # me			59		--

m = Music::Meter.new(3, 4, 1) # 3/4 time, quarter note pulses
b = Music::BeatPosition.new
b.measure     = 0
b.beat        = 2 # 0-based: beat 3 
b.subbeat     = 0 # 0-based: first subbeat
b.beats_per_measure = 3 # 0-based: beat 3 
b.subbeats_per_beat = 1 # 0-based: first subbeatision

$meter_vectors["Bring back my bonnie to me"] =
  {
    :meter               => m,
    :first_beat_position => b,
    :note_queue          => nq
  }

phrases = [ ]
phrases.push({ :start_idx =>  0, :end_idx =>  8 })
phrases.push({ :start_idx =>  9, :end_idx => 16 })
phrases.push({ :start_idx => 17, :end_idx => 25 })
phrases.push({ :start_idx => 26, :end_idx => 33 })
phrases.push({ :start_idx => 34, :end_idx => 37 })
phrases.push({ :start_idx => 38, :end_idx => 47 })
phrases.push({ :start_idx => 48, :end_idx => 51 })
phrases.push({ :start_idx => 52, :end_idx => 59 })

$phrasing_vectors["Bring back my bonnie to me"] =
  {
    :note_queue          => nq,
    :phrase_boundaries   => phrases
  }



###############################################################################
# Battle Hymn of the Republic
###############################################################################

nq = Music::NoteQueue.new
nq.tempo = 100

nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(1)) # mine		 0		++

nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(3)) # eyes		 1
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(1)) # have		 2
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(3)) # seen		 3
nq.push Music::Note.new(Music::Pitch.new(PF4), Music::Duration.new(1)) # the		 4
nq.push Music::Note.new(Music::Pitch.new(PE4), Music::Duration.new(2)) # glo-		 5
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(2)) # -ry		 6
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(2)) # of			 7
nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(2)) # the		 8

nq.push Music::Note.new(Music::Pitch.new(PE5), Music::Duration.new(3)) # com-		 9
nq.push Music::Note.new(Music::Pitch.new(PE5), Music::Duration.new(1)) # -ing		10
nq.push Music::Note.new(Music::Pitch.new(PE5), Music::Duration.new(3)) # of			11
nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(1)) # the		12
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(4)) # lord;		13		--
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(2)) # he			14		++
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(2)) # is			15

nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(3)) # tramp-		16
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(1)) # -ling		17
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(3)) # out		18
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) # the		19
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(3)) # vint-		20
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) # -age		21
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(3)) # where		22
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(1)) # the		23

nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(3)) # grapes		24
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(1)) # of			25
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(3)) # wrath		26
nq.push Music::Note.new(Music::Pitch.new(PE4), Music::Duration.new(1)) # are		27
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(4)) # stor'd;	28		--
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(2)) # he			29		++
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(2)) # hath		30

nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(3)) # loosed		31
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(1)) # the		32
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(3)) # fate-		33
nq.push Music::Note.new(Music::Pitch.new(PF4), Music::Duration.new(1)) # -ful		34
nq.push Music::Note.new(Music::Pitch.new(PE4), Music::Duration.new(2)) # light-		35
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(2)) # -ning		36
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(2)) # of			37
nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(2)) # his		38

nq.push Music::Note.new(Music::Pitch.new(PE5), Music::Duration.new(3)) # ter-		39
nq.push Music::Note.new(Music::Pitch.new(PE5), Music::Duration.new(1)) # -ri-		40
nq.push Music::Note.new(Music::Pitch.new(PE5), Music::Duration.new(3)) # -ble		41
nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(1)) # swift		42
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(4)) # sword;		43		--
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(4)) # his		44		++

nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(4)) # truth		45
nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(4)) # is			46
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(4)) # march-		47
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(4)) # -ing		48

nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(16)) # on		49		--


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

phrases = [ ]
phrases.push({ :start_idx =>  0, :end_idx => 13 })
phrases.push({ :start_idx => 14, :end_idx => 28 })
phrases.push({ :start_idx => 29, :end_idx => 43 })
phrases.push({ :start_idx => 44, :end_idx => 49 })

$phrasing_vectors["Battle hymn of the republic"] =
  {
    :note_queue          => nq,
    :phrase_boundaries   => phrases
  }


###############################################################################
# Bach - Minuet in G
###############################################################################

nq = Music::NoteQueue.new
nq.tempo = 100

nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(2))		#  0	++
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(1)) 		#  1
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(1)) 		#  2
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) 		#  3
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(1)) 		#  4
  
nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(2)) 		#  5
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(2)) 		#  6
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(2)) 		#  7	--

nq.push Music::Note.new(Music::Pitch.new(PE5), Music::Duration.new(2)) 		#  8	++
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(1)) 		#  9
nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(1)) 		# 10
nq.push Music::Note.new(Music::Pitch.new(PE5), Music::Duration.new(1)) 		# 11
nq.push Music::Note.new(Music::Pitch.new(PFs5),Music::Duration.new(1)) 		# 12
  
nq.push Music::Note.new(Music::Pitch.new(PG5), Music::Duration.new(2)) 		# 13
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(2)) 		# 14
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(2)) 		# 15	--

nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(2)) 		# 16	++
nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new(1)) 		# 17
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(1)) 		# 18
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) 		# 19
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(1))		# 20	--

nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(2)) 		# 21	++
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(1)) 		# 22
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) 		# 23
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(1)) 		# 24
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(1)) 		# 25	--

nq.push Music::Note.new(Music::Pitch.new(PFs4),Music::Duration.new(2)) 		# 26	++
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(1)) 		# 27
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(1)) 		# 28
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(1)) 		# 29
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(1)) 		# 30

nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(6))		# 31	--

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

phrases = [ ]
phrases.push({ :start_idx =>  0, :end_idx =>  7 })
phrases.push({ :start_idx =>  8, :end_idx => 15 })

# Any of these continuations seems plausible:

#phrases.push({ :start_idx => 16, :end_idx => 20 })
#phrases.push({ :start_idx => 21, :end_idx => 25 })
#phrases.push({ :start_idx => 26, :end_idx => 31 })

phrases.push({ :start_idx => 16, :end_idx => 25 })
phrases.push({ :start_idx => 26, :end_idx => 31 })

#phrases.push({ :start_idx => 16, :end_idx => 20 })
#phrases.push({ :start_idx => 21, :end_idx => 25 })
#phrases.push({ :start_idx => 26, :end_idx => 30 })
#phrases.push({ :start_idx => 31, :end_idx => 31 })

$phrasing_vectors["Bach Minuet in G"] =
  {
    :note_queue          => nq,
    :phrase_boundaries   => phrases
  }


###############################################################################
# Somewhere over the rainbow
###############################################################################

nq = Music::NoteQueue.new
nq.tempo = 100

nq.push Music::Note.new(Music::Pitch.new(PC4), Music::Duration.new(4)) # some-		 0		++
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(4)) # -where		 1

nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(2)) # ov-		 2
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(1)) # -er		 3
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(1)) # the		 4
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new(2)) # rain-		 5
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(2)) # -bow		 6		--

nq.push Music::Note.new(Music::Pitch.new(PC4), Music::Duration.new(4)) # way		 7		++
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new(4)) # up			 8

nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new(8)) # high		 9		--

nq.push Music::Note.new(Music::Pitch.new(PA3), Music::Duration.new(4)) # there's	10		++
nq.push Music::Note.new(Music::Pitch.new(PF4), Music::Duration.new(4)) # a			11

nq.push Music::Note.new(Music::Pitch.new(PE4), Music::Duration.new(2)) # land		12
nq.push Music::Note.new(Music::Pitch.new(PC4), Music::Duration.new(1)) # that		13
nq.push Music::Note.new(Music::Pitch.new(PD4), Music::Duration.new(1)) # I			14
nq.push Music::Note.new(Music::Pitch.new(PE4), Music::Duration.new(2)) # heard		15
nq.push Music::Note.new(Music::Pitch.new(PF4), Music::Duration.new(2)) # of			16		--

nq.push Music::Note.new(Music::Pitch.new(PD4), Music::Duration.new(2)) # once		17		++
nq.push Music::Note.new(Music::Pitch.new(PB3), Music::Duration.new(1)) # in			18
nq.push Music::Note.new(Music::Pitch.new(PC4), Music::Duration.new(1)) # a			19
nq.push Music::Note.new(Music::Pitch.new(PD4), Music::Duration.new(2)) # lu-		20
nq.push Music::Note.new(Music::Pitch.new(PE4), Music::Duration.new(2)) # -la-		21

nq.push Music::Note.new(Music::Pitch.new(PC4), Music::Duration.new(8)) # -by		22		--

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

phrases = [ ]
phrases.push({ :start_idx =>  0, :end_idx =>  6 })
phrases.push({ :start_idx =>  7, :end_idx =>  9 })
phrases.push({ :start_idx => 10, :end_idx => 16 })
phrases.push({ :start_idx => 17, :end_idx => 22 })

$phrasing_vectors["Somewhere over the rainbow"] =
  {
    :note_queue          => nq,
    :phrase_boundaries   => phrases
  }


###############################################################################
# This train is bound for glory
###############################################################################

nq = Music::NoteQueue.new
nq.tempo = 100

nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(2)) # this		 0	++
nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(4)) # train		 1
nq.push Music::Note.new(Music::Pitch.new(PGs4), Music::Duration.new(2)) # is 		 2
nq.push Music::Note.new(Music::Pitch.new(PFs4), Music::Duration.new(3)) # bound		 3
nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(1)) # for		 4
nq.push Music::Note.new(Music::Pitch.new(PCs4), Music::Duration.new(2)) # glo-		 5
nq.push Music::Note.new(Music::Pitch.new(PB3 ), Music::Duration.new(2)) # -ry		 6

nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(2)) # this		 7
nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(14)) # train	 8	--

nq.push Music::Note.new(Music::Pitch.new(PB4 ), Music::Duration.new(2)) # this		 9	++
nq.push Music::Note.new(Music::Pitch.new(PB4 ), Music::Duration.new(4)) # train		10
nq.push Music::Note.new(Music::Pitch.new(PE5 ), Music::Duration.new(2)) # is 		11
nq.push Music::Note.new(Music::Pitch.new(PCs5), Music::Duration.new(3)) # bound		12
nq.push Music::Note.new(Music::Pitch.new(PB4 ), Music::Duration.new(1)) # for		13
nq.push Music::Note.new(Music::Pitch.new(PGs4), Music::Duration.new(2)) # glo-		14
nq.push Music::Note.new(Music::Pitch.new(PB4 ), Music::Duration.new(2)) # -ry		15

nq.push Music::Note.new(Music::Pitch.new(PB4 ), Music::Duration.new(2)) # this		16
nq.push Music::Note.new(Music::Pitch.new(PB4 ), Music::Duration.new(14)) # train	17	--

nq.push Music::Note.new(Music::Pitch.new(PB4 ), Music::Duration.new(2)) # this		18	++
nq.push Music::Note.new(Music::Pitch.new(PB4 ), Music::Duration.new(4)) # train		19
nq.push Music::Note.new(Music::Pitch.new(PE5 ), Music::Duration.new(2)) # is 		20
nq.push Music::Note.new(Music::Pitch.new(PCs5), Music::Duration.new(3)) # bound		21
nq.push Music::Note.new(Music::Pitch.new(PB4 ), Music::Duration.new(1)) # for		22
nq.push Music::Note.new(Music::Pitch.new(PGs4), Music::Duration.new(2)) # glo-		23
nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(2)) # -ry		24	--

nq.push Music::Note.new(Music::Pitch.new(PFs4), Music::Duration.new(2)) # don't		25	++
nq.push Music::Note.new(Music::Pitch.new(PFs4), Music::Duration.new(2)) # take		26
nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(1)) # no-		27
nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(1)) # -thing	28
nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(1)) # but		29
nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(1)) # the		30
nq.push Music::Note.new(Music::Pitch.new(PGs4), Music::Duration.new(1)) # right-	31
nq.push Music::Note.new(Music::Pitch.new(PGs4), Music::Duration.new(1)) # -eous		32
nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(1)) # an'		33
nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(1)) # the		34
nq.push Music::Note.new(Music::Pitch.new(PCs4), Music::Duration.new(2)) # ho-		35
nq.push Music::Note.new(Music::Pitch.new(PB3 ), Music::Duration.new(2)) # -ly		36	--

nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(2)) # this		37	++
nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(4)) # train		38
nq.push Music::Note.new(Music::Pitch.new(PGs4), Music::Duration.new(2)) # is 		39
nq.push Music::Note.new(Music::Pitch.new(PFs4), Music::Duration.new(3)) # bound		40
nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(1)) # for		41
nq.push Music::Note.new(Music::Pitch.new(PCs4), Music::Duration.new(2)) # glo-		42
nq.push Music::Note.new(Music::Pitch.new(PB3 ), Music::Duration.new(2)) # -ry		43

nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(2)) # this		44
nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(14)) # train	45	--

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

phrases = [ ]
phrases.push({ :start_idx =>  0, :end_idx =>  8 })
phrases.push({ :start_idx =>  9, :end_idx => 17 })

#phrases.push({ :start_idx => 18, :end_idx => 24 })
#phrases.push({ :start_idx => 25, :end_idx => 36 })
phrases.push({ :start_idx => 18, :end_idx => 36 }) # this keeps the phrase lengths the same...

phrases.push({ :start_idx => 37, :end_idx => 45 })

$phrasing_vectors["This train is bound for glory"] =
  {
    :note_queue          => nq,
    :phrase_boundaries   => phrases
  }


###############################################################################
# Bach Minuet (2)
###############################################################################

nq = Music::NoteQueue.new
nq.tempo = 100

nq.push Music::Note.new(Music::Pitch.new(PD5 ), Music::Duration.new(2)) 	#  0	++
nq.push Music::Note.new(Music::Pitch.new(PD5 ), Music::Duration.new(2))		#  1
nq.push Music::Note.new(Music::Pitch.new(PD5 ), Music::Duration.new(2))		#  2

nq.push Music::Note.new(Music::Pitch.new(PB4 ), Music::Duration.new(2))		#  3
nq.push Music::Note.new(Music::Pitch.new(PA4 ), Music::Duration.new(1))		#  4
nq.push Music::Note.new(Music::Pitch.new(PB4 ), Music::Duration.new(1))		#  5
nq.push Music::Note.new(Music::Pitch.new(PG4 ), Music::Duration.new(2))		#  6	--

nq.push Music::Note.new(Music::Pitch.new(PA4 ), Music::Duration.new(2)) 	#  7	++
nq.push Music::Note.new(Music::Pitch.new(PD5 ), Music::Duration.new(2))		#  8
nq.push Music::Note.new(Music::Pitch.new(PC5 ), Music::Duration.new(2))		#  9

nq.push Music::Note.new(Music::Pitch.new(PB4 ), Music::Duration.new(4)) 	# 10
nq.push Music::Note.new(Music::Pitch.new(PA4 ), Music::Duration.new(2))		# 11	--

nq.push Music::Note.new(Music::Pitch.new(PD5 ), Music::Duration.new(2))		# 12	++
nq.push Music::Note.new(Music::Pitch.new(PC5 ), Music::Duration.new(1))		# 13
nq.push Music::Note.new(Music::Pitch.new(PB4 ), Music::Duration.new(1))		# 14
nq.push Music::Note.new(Music::Pitch.new(PA4 ), Music::Duration.new(1))		# 15
nq.push Music::Note.new(Music::Pitch.new(PG4 ), Music::Duration.new(1))		# 16	--

nq.push Music::Note.new(Music::Pitch.new(PE5 ), Music::Duration.new(2))		# 17	++
nq.push Music::Note.new(Music::Pitch.new(PC5 ), Music::Duration.new(1))		# 18
nq.push Music::Note.new(Music::Pitch.new(PB4 ), Music::Duration.new(1))		# 19
nq.push Music::Note.new(Music::Pitch.new(PA4 ), Music::Duration.new(1))		# 20
nq.push Music::Note.new(Music::Pitch.new(PG4 ), Music::Duration.new(1))		# 21	--

nq.push Music::Note.new(Music::Pitch.new(PFs4), Music::Duration.new(2))		# 22	++
nq.push Music::Note.new(Music::Pitch.new(PE4 ), Music::Duration.new(1))		# 23
nq.push Music::Note.new(Music::Pitch.new(PD4 ), Music::Duration.new(1))		# 24
nq.push Music::Note.new(Music::Pitch.new(PFs4), Music::Duration.new(2))		# 25

nq.push Music::Note.new(Music::Pitch.new(PG4 ), Music::Duration.new(6)) 	# 26	--

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

phrases = [ ]
phrases.push({ :start_idx =>  0, :end_idx =>  6 })
phrases.push({ :start_idx =>  7, :end_idx => 11 })
phrases.push({ :start_idx => 12, :end_idx => 16 })
phrases.push({ :start_idx => 17, :end_idx => 21 })
phrases.push({ :start_idx => 22, :end_idx => 26 })

$phrasing_vectors["Bach Minuet (2)"] =
  {
    :note_queue          => nq,
    :phrase_boundaries   => phrases
  }

###############################################################################
# Amazing Grace
###############################################################################

nq = Music::NoteQueue.new
nq.tempo = 100

nq.push Music::Note.new(Music::Pitch.new(PC4), Music::Duration.new( 1))		#  0	++
nq.push Music::Note.new(Music::Pitch.new(PF4), Music::Duration.new( 1))		#  1

nq.push Music::Note.new(Music::Pitch.new(PF4), Music::Duration.new( 4))		#  2
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new( 1))		#  3
nq.push Music::Note.new(Music::Pitch.new(PF4), Music::Duration.new( 1))		#  4

nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new( 4))		#  5	--
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new( 2))		#  6	++

nq.push Music::Note.new(Music::Pitch.new(PF4), Music::Duration.new( 4))		#  7
nq.push Music::Note.new(Music::Pitch.new(PD4), Music::Duration.new( 2))		#  8

nq.push Music::Note.new(Music::Pitch.new(PC4), Music::Duration.new( 4))		#  9	--
nq.push Music::Note.new(Music::Pitch.new(PC4), Music::Duration.new( 1))		# 10	++
nq.push Music::Note.new(Music::Pitch.new(PF4), Music::Duration.new( 1))		# 11

nq.push Music::Note.new(Music::Pitch.new(PF4), Music::Duration.new( 4))		# 12
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new( 1))		# 13
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new( 1))		# 14

nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new( 4))		# 15
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new( 2))		# 16

nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new(10))		# 17	--
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new( 1))		# 18	++
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new( 1))		# 19

nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new( 4))		# 20
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new( 1))		# 21
nq.push Music::Note.new(Music::Pitch.new(PF4), Music::Duration.new( 1))		# 22

nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new( 4))		# 23	--
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new( 2))		# 24	++

nq.push Music::Note.new(Music::Pitch.new(PF4), Music::Duration.new( 4))		# 25
nq.push Music::Note.new(Music::Pitch.new(PD4), Music::Duration.new( 2))		# 26

nq.push Music::Note.new(Music::Pitch.new(PC4), Music::Duration.new( 4))		# 27	--
nq.push Music::Note.new(Music::Pitch.new(PC4), Music::Duration.new( 1))		# 28	++
nq.push Music::Note.new(Music::Pitch.new(PF4), Music::Duration.new( 1))		# 29

nq.push Music::Note.new(Music::Pitch.new(PF4), Music::Duration.new( 4))		# 30
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new( 1))		# 31
nq.push Music::Note.new(Music::Pitch.new(PF4), Music::Duration.new( 1))		# 32

nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new( 4))		# 33
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new( 2))		# 34

nq.push Music::Note.new(Music::Pitch.new(PF4), Music::Duration.new(12))		# 35	--

m = Music::Meter.new(3, 4, 2) # 3/4 time, eighth note pulses
b = Music::BeatPosition.new
b.measure     = 0
b.beat        = 2 # 0-based: third beat
b.subbeat     = 1 # 0-based: second eighth note
b.beats_per_measure = 3 # 3 beats
b.subbeats_per_beat = 2 # half of quarter notes

$meter_vectors["Amazing Grace"] =
  {
    :meter               => m,
    :first_beat_position => b,
    :note_queue          => nq
  }

phrases = [ ]
phrases.push({ :start_idx =>  0, :end_idx =>  5 })
phrases.push({ :start_idx =>  6, :end_idx =>  9 })
phrases.push({ :start_idx => 10, :end_idx => 17 })
phrases.push({ :start_idx => 18, :end_idx => 23 })
phrases.push({ :start_idx => 24, :end_idx => 35 })

$phrasing_vectors["Amazing Grace"] =
  {
    :note_queue          => nq,
    :phrase_boundaries   => phrases
  }

###############################################################################
# Ode to Joy
###############################################################################

nq = Music::NoteQueue.new
nq.tempo = 100

nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new( 2))		#  0 ++
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new( 2))		#  1
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new( 2))		#  2
nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new( 2))		#  3

nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new( 2))		#  4
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new( 2))		#  5
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new( 2))		#  6
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new( 2))		#  7

nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new( 2))		#  8
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new( 2))		#  9
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new( 2))		# 10
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new( 2))		# 11

nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new( 3))		# 12
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new( 1))		# 13
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new( 4))		# 14 --

nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new( 2))		# 15 ++
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new( 2))		# 16
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new( 2))		# 17
nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new( 2))		# 18

nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new( 2))		# 19
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new( 2))		# 20
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new( 2))		# 21
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new( 2))		# 22

nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new( 2))		# 23
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new( 2))		# 24
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new( 2))		# 25
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new( 2))		# 26

nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new( 3))		# 27
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new( 1))		# 28
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new( 4))		# 29 --

nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new( 2))		# 30 ++
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new( 2))		# 31
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new( 2))		# 32
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new( 2))		# 33

nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new( 2))		# 34
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new( 1))		# 35
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new( 1))		# 36
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new( 2))		# 37
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new( 2))		# 38

nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new( 2))		# 39
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new( 1))		# 40
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new( 1))		# 41
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new( 2))		# 42
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new( 2))		# 43

nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new( 2))		# 44
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new( 2))		# 45
nq.push Music::Note.new(Music::Pitch.new(PD4), Music::Duration.new( 4))		# 46 --

nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new( 2))		# 47 ++
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new( 2))		# 48
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new( 2))		# 49
nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new( 2))		# 50

nq.push Music::Note.new(Music::Pitch.new(PD5), Music::Duration.new( 2))		# 51
nq.push Music::Note.new(Music::Pitch.new(PC5), Music::Duration.new( 2))		# 52
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new( 2))		# 53
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new( 2))		# 54

nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new( 2))		# 55
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new( 2))		# 56
nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new( 2))		# 57
nq.push Music::Note.new(Music::Pitch.new(PB4), Music::Duration.new( 2))		# 58

nq.push Music::Note.new(Music::Pitch.new(PA4), Music::Duration.new( 3))		# 59
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new( 1))		# 60
nq.push Music::Note.new(Music::Pitch.new(PG4), Music::Duration.new( 4))		# 61 --

m = Music::Meter.new(4, 4, 2) # 3/4 time, eighth note pulses
b = Music::BeatPosition.new
b.measure     = 0
b.beat        = 0 # 0-based: first beat
b.subbeat     = 0 # 0-based: first eight not
b.beats_per_measure = 4 # 4 beats
b.subbeats_per_beat = 2 # half of quarter notes (eighth notes)

$meter_vectors["Ode to Joy"] =
  {
    :meter               => m,
    :first_beat_position => b,
    :note_queue          => nq
  }

phrases = [ ]
phrases.push({ :start_idx =>  0, :end_idx => 14 })
phrases.push({ :start_idx => 15, :end_idx => 29 })
phrases.push({ :start_idx => 30, :end_idx => 46 })
phrases.push({ :start_idx => 47, :end_idx => 61 })

$phrasing_vectors["Ode to Joy"] =
  {
    :note_queue          => nq,
    :phrase_boundaries   => phrases
  }


