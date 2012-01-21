#!/usr/bin/env ruby 

require 'spec_helper'

describe Music::PhraseList do
  before do
  end

  context "new" do
    it "should take a note queue" do
      vector = $phrasing_vectors["Bring back my bonnie to me"]
      nq = vector[:note_queue]
      Music::PhraseList.new(nq).should be_an_instance_of Music::PhraseList
    end
  end

  context "initial" do
    before(:all) do
      vector = $phrasing_vectors["Bring back my bonnie to me"]
      @nq = vector[:note_queue]
    end
    it "should return a phrase list" do
      Music::PhraseList.initial(@nq).should be_an_instance_of Music::PhraseList
    end
    it "should contain at least one phrase" do
      pl = Music::PhraseList.initial(@nq)
      pl.length.should be >= 1
    end
  end

  context "clone" do
    before(:all) do
      vector = $phrasing_vectors["Bring back my bonnie to me"]
      @nq = vector[:note_queue]
    end
    it "returns an equivalent Phrase_list" do
      pl = Music::PhraseList.initial(@nq)
      pl.clone.to_s.should == pl.to_s
    end
    it "returns a new PhraseList (not the same one)" do
      pl = Music::PhraseList.initial(@nq)
      pl.clone.should_not be pl
    end
  end

  context "score" do
    it "returns a float" do
      @vector = $phrasing_vectors["Bring back my bonnie to me"]
      @nq = @vector[:note_queue]
      pl = Music::PhraseList.initial(@nq)
      pl.score.should be_an_instance_of Float
    end

    it "returns a higher value for the correct phrasing than for other phrasings (1 - merged two phrases)" do
      @vector = $phrasing_vectors["Bring back my bonnie to me"]
      @nq = @vector[:note_queue]
      @nq.create_intervals
      correct_pl = Music::PhraseList.new(@nq)
      @vector[:phrase_boundaries].each do |p|
        correct_pl.push Music::Phrase.new(@nq, p[:start_idx], p[:end_idx])
      end

      incorrect_pl = Music::PhraseList.new(@nq)
      incorrect_pl.push Music::Phrase.new(@nq,  0, 16) ## Combined 0 & 1
      incorrect_pl.push Music::Phrase.new(@nq, 17, 25)
      incorrect_pl.push Music::Phrase.new(@nq, 26, 33)
      incorrect_pl.push Music::Phrase.new(@nq, 34, 37)
      incorrect_pl.push Music::Phrase.new(@nq, 38, 47)
      incorrect_pl.push Music::Phrase.new(@nq, 48, 51)
      incorrect_pl.push Music::Phrase.new(@nq, 52, 59)

      incorrect_pl.score.should be < correct_pl.score
    end

    it "returns a higher value for the correct phrasing than for other phrasings (2 - shift all boundaries by 1)" do
      @vector = $phrasing_vectors["Bring back my bonnie to me"]
      @nq = @vector[:note_queue]
      @nq.create_intervals
      correct_pl = Music::PhraseList.new(@nq)
      @vector[:phrase_boundaries].each do |p|
        correct_pl.push Music::Phrase.new(@nq, p[:start_idx], p[:end_idx])
      end

      incorrect_pl = Music::PhraseList.new(@nq)
      incorrect_pl.push Music::Phrase.new(@nq,  0,  9) # bumped up all boundaries by 1
      incorrect_pl.push Music::Phrase.new(@nq, 10, 17)
      incorrect_pl.push Music::Phrase.new(@nq, 18, 26)
      incorrect_pl.push Music::Phrase.new(@nq, 27, 34)
      incorrect_pl.push Music::Phrase.new(@nq, 35, 38)
      incorrect_pl.push Music::Phrase.new(@nq, 39, 48)
      incorrect_pl.push Music::Phrase.new(@nq, 49, 51)
      incorrect_pl.push Music::Phrase.new(@nq, 52, 59)

      incorrect_pl.score.should be < correct_pl.score
    end
 
    it "returns a higher value for the correct phrasing than for other phrasings (3 - merged pairs of phrases)" do
      @vector = $phrasing_vectors["Bring back my bonnie to me"]
      @nq = @vector[:note_queue]
      @nq.create_intervals
      correct_pl = Music::PhraseList.new(@nq)
      @vector[:phrase_boundaries].each do |p|
        correct_pl.push Music::Phrase.new(@nq, p[:start_idx], p[:end_idx])
      end

      incorrect_pl = Music::PhraseList.new(@nq)
      incorrect_pl.push Music::Phrase.new(@nq,  0, 16) # merged successive pairs
      incorrect_pl.push Music::Phrase.new(@nq, 17, 35)
      incorrect_pl.push Music::Phrase.new(@nq, 34, 47)
      incorrect_pl.push Music::Phrase.new(@nq, 48, 59)

      incorrect_pl.score.should be < correct_pl.score
    end

    it "returns a higher value for the correct phrasing than for other phrasings (4 - merged some phrase pairs)" do
      @vector = $phrasing_vectors["Bach Minuet in G"]
      @nq = @vector[:note_queue]
      @nq.create_intervals
      correct_pl = Music::PhraseList.new(@nq)
      @vector[:phrase_boundaries].each do |p|
        correct_pl.push Music::Phrase.new(@nq, p[:start_idx], p[:end_idx])
      end

      incorrect_pl = Music::PhraseList.new(@nq)
      incorrect_pl.push Music::Phrase.new(@nq,  0, 15)  # combined 0 and 1
      incorrect_pl.push Music::Phrase.new(@nq, 16, 25)  # combined 2 and 3
      incorrect_pl.push Music::Phrase.new(@nq, 26, 31)

      incorrect_pl.score.should be < correct_pl.score
    end

    it "returns a higher value for the correct phrasing than for other phrasings (5 - split first phrase)" do
      @vector = $phrasing_vectors["Bach Minuet in G"]
      @nq = @vector[:note_queue]
      @nq.create_intervals
      correct_pl = Music::PhraseList.new(@nq)
      @vector[:phrase_boundaries].each do |p|
        correct_pl.push Music::Phrase.new(@nq, p[:start_idx], p[:end_idx])
      end

      incorrect_pl = Music::PhraseList.new(@nq)
      incorrect_pl.push Music::Phrase.new(@nq,  0,  1)  # split 0-7 into 0-1, 2,7
      incorrect_pl.push Music::Phrase.new(@nq,  2,  7) 
      incorrect_pl.push Music::Phrase.new(@nq,  8, 15)
      incorrect_pl.push Music::Phrase.new(@nq, 16, 20)
      incorrect_pl.push Music::Phrase.new(@nq, 21, 25)
      incorrect_pl.push Music::Phrase.new(@nq, 26, 31)

      incorrect_pl.score.should be < correct_pl.score
    end

    it "returns a higher value for the correct phrasing than for other phrasings (6 - split all phrases in half)" do
      @vector = $phrasing_vectors["Bach Minuet in G"]
      @nq = @vector[:note_queue]
      @nq.create_intervals
      correct_pl = Music::PhraseList.new(@nq)
      @vector[:phrase_boundaries].each do |p|
        correct_pl.push Music::Phrase.new(@nq, p[:start_idx], p[:end_idx])
      end

      incorrect_pl = Music::PhraseList.new(@nq)
      incorrect_pl.push Music::Phrase.new(@nq,  0,  3)  # split phrases in half
      incorrect_pl.push Music::Phrase.new(@nq,  4,  7) 
      incorrect_pl.push Music::Phrase.new(@nq,  8, 11)
      incorrect_pl.push Music::Phrase.new(@nq, 12, 15)
      incorrect_pl.push Music::Phrase.new(@nq, 16, 18)
      incorrect_pl.push Music::Phrase.new(@nq, 19, 20)
      incorrect_pl.push Music::Phrase.new(@nq, 21, 22)
      incorrect_pl.push Music::Phrase.new(@nq, 23, 25)
      incorrect_pl.push Music::Phrase.new(@nq, 26, 28)
      incorrect_pl.push Music::Phrase.new(@nq, 29, 31)

      incorrect_pl.score.should be < correct_pl.score
    end

    it "returns a higher value for the correct phrasing than for other phrasings (7 - shifted all boundaries back by 1)" do
      @vector = $phrasing_vectors["Bach Minuet in G"]
      @nq = @vector[:note_queue]
      @nq.create_intervals
      correct_pl = Music::PhraseList.new(@nq)
      @vector[:phrase_boundaries].each do |p|
        correct_pl.push Music::Phrase.new(@nq, p[:start_idx], p[:end_idx])
      end

      incorrect_pl = Music::PhraseList.new(@nq)
      incorrect_pl.push Music::Phrase.new(@nq,  0,  8)  # shifted all boundaries back by 1
      incorrect_pl.push Music::Phrase.new(@nq,  9, 16)
      incorrect_pl.push Music::Phrase.new(@nq, 17, 21)
      incorrect_pl.push Music::Phrase.new(@nq, 22, 26)
      incorrect_pl.push Music::Phrase.new(@nq, 27, 31)

      incorrect_pl.score.should be < correct_pl.score
    end

    it "returns a higher value for the correct phrasing than for other phrasings (8 - shifted all boundaries up by 1)" do
      @vector = $phrasing_vectors["Bach Minuet in G"]
      @nq = @vector[:note_queue]
      @nq.create_intervals
      correct_pl = Music::PhraseList.new(@nq)
      @vector[:phrase_boundaries].each do |p|
        correct_pl.push Music::Phrase.new(@nq, p[:start_idx], p[:end_idx])
      end

      incorrect_pl = Music::PhraseList.new(@nq)
      incorrect_pl.push Music::Phrase.new(@nq,  0,  6)  # shifted all boundaries up by 1
      incorrect_pl.push Music::Phrase.new(@nq,  8, 14)
      incorrect_pl.push Music::Phrase.new(@nq, 15, 19)
      incorrect_pl.push Music::Phrase.new(@nq, 20, 24)
      incorrect_pl.push Music::Phrase.new(@nq, 25, 31)

      incorrect_pl.score.should be < correct_pl.score
    end

    it "returns a higher value for the correct phrasing than for other phrasings (9 - split 1st 2 phrases)" do
      @vector = $phrasing_vectors["Battle hymn of the republic"]
      @nq = @vector[:note_queue]
      @nq.create_intervals
      correct_pl = Music::PhraseList.new(@nq)
      @vector[:phrase_boundaries].each do |p|
        correct_pl.push Music::Phrase.new(@nq, p[:start_idx], p[:end_idx])
      end

      incorrect_pl = Music::PhraseList.new(@nq)
      incorrect_pl.push Music::Phrase.new(@nq,  0,  6)
      incorrect_pl.push Music::Phrase.new(@nq,  7, 13)
      incorrect_pl.push Music::Phrase.new(@nq, 14, 20)
      incorrect_pl.push Music::Phrase.new(@nq, 21, 28)
      incorrect_pl.push Music::Phrase.new(@nq, 29, 43)
      incorrect_pl.push Music::Phrase.new(@nq, 44, 49)

      incorrect_pl.score.should be < correct_pl.score
    end

    it "returns a higher value for the correct phrasing than for other phrasings (10 - wrong but totally uniform length)" do
      @vector = $phrasing_vectors["Battle hymn of the republic"]
      @nq = @vector[:note_queue]
      @nq.create_intervals
      correct_pl = Music::PhraseList.new(@nq)
      @vector[:phrase_boundaries].each do |p|
        correct_pl.push Music::Phrase.new(@nq, p[:start_idx], p[:end_idx])
      end

      incorrect_pl = Music::PhraseList.new(@nq)
      incorrect_pl.push Music::Phrase.new(@nq,  0,  4)
      incorrect_pl.push Music::Phrase.new(@nq,  5,  9)
      incorrect_pl.push Music::Phrase.new(@nq, 10, 14)
      incorrect_pl.push Music::Phrase.new(@nq, 15, 19)
      incorrect_pl.push Music::Phrase.new(@nq, 20, 24)
      incorrect_pl.push Music::Phrase.new(@nq, 25, 29)
      incorrect_pl.push Music::Phrase.new(@nq, 30, 34)
      incorrect_pl.push Music::Phrase.new(@nq, 35, 39)
      incorrect_pl.push Music::Phrase.new(@nq, 40, 44)
      incorrect_pl.push Music::Phrase.new(@nq, 45, 49)

      incorrect_pl.score.should be < correct_pl.score
    end

    it "returns a higher value for the correct phrasing than for other phrasings (11 - near miss)" do
      @vector = $phrasing_vectors["Bring back my bonnie to me"]
      @nq = @vector[:note_queue]
      @nq.create_intervals
      correct_pl = Music::PhraseList.new(@nq)
      @vector[:phrase_boundaries].each do |p|
        correct_pl.push Music::Phrase.new(@nq, p[:start_idx], p[:end_idx])
      end

      incorrect_pl = Music::PhraseList.new(@nq)
      incorrect_pl.push Music::Phrase.new(@nq,  0, 15)
      incorrect_pl.push Music::Phrase.new(@nq, 16, 17)
      incorrect_pl.push Music::Phrase.new(@nq, 18, 32)
      incorrect_pl.push Music::Phrase.new(@nq, 33, 47)
      incorrect_pl.push Music::Phrase.new(@nq, 48, 59)

      incorrect_pl.score.should be < correct_pl.score
    end

    it "returns a higher value for the correct phrasing than for other phrasings (12 - one long phrase)" do
      @vector = $phrasing_vectors["Battle hymn of the republic"]
      @nq = @vector[:note_queue]
      @nq.create_intervals
      correct_pl = Music::PhraseList.new(@nq)
      @vector[:phrase_boundaries].each do |p|
        correct_pl.push Music::Phrase.new(@nq, p[:start_idx], p[:end_idx])
      end

      incorrect_pl = Music::PhraseList.new(@nq)
      incorrect_pl.push Music::Phrase.new(@nq,  0, 49)

      incorrect_pl.score.should be < correct_pl.score
    end

    it "returns a higher value for the correct phrasing than for other phrasings (13 - near miss)" do
      @vector = $phrasing_vectors["Bach Minuet in G"]
      @nq = @vector[:note_queue]
      @nq.create_intervals
      correct_pl = Music::PhraseList.new(@nq)
      @vector[:phrase_boundaries].each do |p|
        correct_pl.push Music::Phrase.new(@nq, p[:start_idx], p[:end_idx])
      end

      incorrect_pl = Music::PhraseList.new(@nq)
      incorrect_pl.push Music::Phrase.new(@nq,  0, 13)
      incorrect_pl.push Music::Phrase.new(@nq, 14, 31)

      incorrect_pl.score.should be < correct_pl.score
    end

    it "returns a higher value for the correct phrasing than for other phrasings (14 - near miss)" do
      @vector = $phrasing_vectors["Somewhere over the rainbow"]
      @nq = @vector[:note_queue]
      @nq.create_intervals
      correct_pl = Music::PhraseList.new(@nq)
      @vector[:phrase_boundaries].each do |p|
        correct_pl.push Music::Phrase.new(@nq, p[:start_idx], p[:end_idx])
      end

      incorrect_pl = Music::PhraseList.new(@nq)
      incorrect_pl.push Music::Phrase.new(@nq,  0,  6)
      incorrect_pl.push Music::Phrase.new(@nq,  7,  9)
      incorrect_pl.push Music::Phrase.new(@nq, 10, 21)
      incorrect_pl.push Music::Phrase.new(@nq, 22, 22)

      incorrect_pl.score.should be < correct_pl.score
    end

    it "returns a higher value for the correct phrasing than for other phrasings (15 - merged pairs/trios of phrases)" do
      @vector = $phrasing_vectors["Bach Minuet (2)"]
      @nq = @vector[:note_queue]
      @nq.create_intervals
      correct_pl = Music::PhraseList.new(@nq)
      @vector[:phrase_boundaries].each do |p|
        correct_pl.push Music::Phrase.new(@nq, p[:start_idx], p[:end_idx])
      end

      incorrect_pl = Music::PhraseList.new(@nq)
      incorrect_pl.push Music::Phrase.new(@nq,  0, 11) # merged 0-6 and 7-11
      incorrect_pl.push Music::Phrase.new(@nq, 12, 26) # merged 12-16, 17-21, and 22-26

      incorrect_pl.score.should be < correct_pl.score
    end

    it "returns a higher value for the correct phrasing than for other phrasings (16 - shifted and merged)" do
      @vector = $phrasing_vectors["Bach Minuet in G"]
      @nq = @vector[:note_queue]
      @nq.create_intervals
      correct_pl = Music::PhraseList.new(@nq)
      @vector[:phrase_boundaries].each do |p|
        correct_pl.push Music::Phrase.new(@nq, p[:start_idx], p[:end_idx])
      end

      incorrect_pl = Music::PhraseList.new(@nq)
      incorrect_pl.push Music::Phrase.new(@nq,  0,  7)
      incorrect_pl.push Music::Phrase.new(@nq,  8, 13) # shifted end back by 2
      incorrect_pl.push Music::Phrase.new(@nq, 14, 21) # grew on both ends
      incorrect_pl.push Music::Phrase.new(@nq, 22, 31) # shifted beginning up by 1. merged w/ next

      incorrect_pl.score.should be < correct_pl.score
    end

    it "returns a higher value for the correct phrasing than for other phrasings (17 - ????)" do
      @vector = $phrasing_vectors["Battle hymn of the republic"]
      @nq = @vector[:note_queue]
      @nq.create_intervals
      correct_pl = Music::PhraseList.new(@nq)
      @vector[:phrase_boundaries].each do |p|
        correct_pl.push Music::Phrase.new(@nq, p[:start_idx], p[:end_idx])
      end

      incorrect_pl = Music::PhraseList.new(@nq)
      incorrect_pl.push Music::Phrase.new(@nq,  0, 11)
      incorrect_pl.push Music::Phrase.new(@nq, 12, 19)
      incorrect_pl.push Music::Phrase.new(@nq, 20, 27)
      incorrect_pl.push Music::Phrase.new(@nq, 28, 36)
      incorrect_pl.push Music::Phrase.new(@nq, 37, 44)
      incorrect_pl.push Music::Phrase.new(@nq, 45, 49)

      incorrect_pl.score.should be < correct_pl.score
    end

    it "returns a higher value for the correct phrasing than for other phrasings (18 - merged & off by one)" do
      @vector = $phrasing_vectors["Bach Minuet (2)"]
      @nq = @vector[:note_queue]
      @nq.create_intervals
      correct_pl = Music::PhraseList.new(@nq)
      @vector[:phrase_boundaries].each do |p|
        correct_pl.push Music::Phrase.new(@nq, p[:start_idx], p[:end_idx])
      end

      incorrect_pl = Music::PhraseList.new(@nq)
      incorrect_pl.push Music::Phrase.new(@nq,  0,  7)
      incorrect_pl.push Music::Phrase.new(@nq,  8, 16)
      incorrect_pl.push Music::Phrase.new(@nq, 17, 26)

      incorrect_pl.score.should be < correct_pl.score
    end

    it "returns a higher value for the correct phrasing than for other phrasings (19 - last phrase starts half-phrase earlier)" do
      @vector = $phrasing_vectors["This train is bound for glory"]
      @nq = @vector[:note_queue]
      @nq.create_intervals
      correct_pl = Music::PhraseList.new(@nq)
      @vector[:phrase_boundaries].each do |p|
        correct_pl.push Music::Phrase.new(@nq, p[:start_idx], p[:end_idx])
      end

      incorrect_pl = Music::PhraseList.new(@nq)
      incorrect_pl.push Music::Phrase.new(@nq,  0,  8)
      incorrect_pl.push Music::Phrase.new(@nq,  9, 17)
      incorrect_pl.push Music::Phrase.new(@nq, 18, 32)
      incorrect_pl.push Music::Phrase.new(@nq, 33, 45)

      incorrect_pl.score.should be < correct_pl.score
    end

    it "returns a higher value for the correct phrasing than for other phrasings (20 - merge two, then start early)" do
      @vector = $phrasing_vectors["Battle hymn of the republic"]
      @nq = @vector[:note_queue]
      @nq.create_intervals
      correct_pl = Music::PhraseList.new(@nq)
      @vector[:phrase_boundaries].each do |p|
        correct_pl.push Music::Phrase.new(@nq, p[:start_idx], p[:end_idx])
      end

      incorrect_pl = Music::PhraseList.new(@nq)
      incorrect_pl.push Music::Phrase.new(@nq,  0, 18)
      incorrect_pl.push Music::Phrase.new(@nq, 19, 36)
      incorrect_pl.push Music::Phrase.new(@nq, 37, 49)

      incorrect_pl.score.should be < correct_pl.score
    end

    it "returns a higher value for the correct phrasing than for other phrasings (21 - merge down to just two phrases)" do
      @vector = $phrasing_vectors["Bring back my bonnie to me"]
      @nq = @vector[:note_queue]
      @nq.create_intervals
      correct_pl = Music::PhraseList.new(@nq)
      @vector[:phrase_boundaries].each do |p|
        correct_pl.push Music::Phrase.new(@nq, p[:start_idx], p[:end_idx])
      end

      incorrect_pl = Music::PhraseList.new(@nq)
      incorrect_pl.push Music::Phrase.new(@nq,  0, 33) 
      incorrect_pl.push Music::Phrase.new(@nq, 34, 59)

      incorrect_pl.score.should be < correct_pl.score
    end

    it "returns a higher value for the correct phrasing than for other phrasings (22 - merged down to just two phrases)" do
      @vector = $phrasing_vectors["Battle hymn of the republic"]
      @nq = @vector[:note_queue]
      @nq.create_intervals
      correct_pl = Music::PhraseList.new(@nq)
      @vector[:phrase_boundaries].each do |p|
        correct_pl.push Music::Phrase.new(@nq, p[:start_idx], p[:end_idx])
      end

      incorrect_pl = Music::PhraseList.new(@nq)
      incorrect_pl.push Music::Phrase.new(@nq,  0, 27)
      incorrect_pl.push Music::Phrase.new(@nq, 28, 49)

      incorrect_pl.score.should be < correct_pl.score
    end

    it "returns a higher value for the correct phrasing than for other phrasings (23 - merged down to just two phrases)" do
      @vector = $phrasing_vectors["Somewhere over the rainbow"]
      @nq = @vector[:note_queue]
      @nq.create_intervals
      correct_pl = Music::PhraseList.new(@nq)
      @vector[:phrase_boundaries].each do |p|
        correct_pl.push Music::Phrase.new(@nq, p[:start_idx], p[:end_idx])
      end

      incorrect_pl = Music::PhraseList.new(@nq)
      incorrect_pl.push Music::Phrase.new(@nq,  0,  9)
      incorrect_pl.push Music::Phrase.new(@nq, 10, 22)

      incorrect_pl.score.should be < correct_pl.score
    end

 end

end
