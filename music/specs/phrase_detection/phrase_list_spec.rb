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

    it "returns a higher value for the correct phrasing than for other phrasings (7 - shifted all boundaries by 1)" do
      @vector = $phrasing_vectors["Bach Minuet in G"]
      @nq = @vector[:note_queue]
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
 end

end
