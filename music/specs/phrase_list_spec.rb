#!/usr/bin/env ruby 

require 'spec_helper'

shared_examples "scores correctly" do |vector, incorrect_phrases|
  it "scores correctly" do
    nq = vector[:note_queue]
    nq.analyze!
    correct_phrase_list = Music::PhraseList.new(nq)
    vector[:phrase_boundaries].each do |p|
      correct_phrase_list.push Music::Phrase.new(nq, p[:start_idx], p[:end_idx])
    end

    incorrect_phrase_list = Music::PhraseList.new(nq)
    incorrect_phrases.each do |start_idx, end_idx|
      incorrect_phrase_list.push Music::Phrase.new(nq, start_idx, end_idx)
    end

    incorrect_phrase_list.score.should be < correct_phrase_list.score
  end
end

describe Music::PhraseList do
  before do
  end

  describe ".new" do
    it "should take a note queue" do
      vector = $phrasing_vectors["Bring back my bonnie to me"]
      nq = vector[:note_queue]
      Music::PhraseList.new(nq).should be_an_instance_of Music::PhraseList
    end
  end

  describe ".initial" do
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

  describe ".clone" do
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

  describe ".score" do
    it "returns a float" do
      @vector = $phrasing_vectors["Bring back my bonnie to me"]
      @nq = @vector[:note_queue]
      @nq.analyze!
      pl = Music::PhraseList.initial(@nq)
      pl.score.should be_an_instance_of Float
    end

    context "Bring back my bonnie to me" do
      context "merged two phrases" do
        incorrect_phrases = [ [0,            16], [17, 25], [26, 33], [34, 37], [38, 47], [48, 51], [52, 59] ]
        it_should_behave_like "scores correctly", $phrasing_vectors["Bring back my bonnie to me"], incorrect_phrases
      end
  
      context "shift all boundaries by 1" do
        incorrect_phrases = [ [ 0,  9], [10, 17], [18, 26], [27, 34], [35, 38], [39, 48], [49, 51], [52, 59] ]
        it_should_behave_like "scores correctly", $phrasing_vectors["Bring back my bonnie to me"], incorrect_phrases
      end
 
      context "merged pairs of phrases" do
        incorrect_phrases = [ [ 0,           16], [17,           33], [34,           47], [48,           59] ] 
        it_should_behave_like "scores correctly", $phrasing_vectors["Bring back my bonnie to me"], incorrect_phrases
      end

      context "near miss" do
        incorrect_phrases = [ [ 0,     15], [16, 17], [18, 32], [33,                 47], [48,           59] ] 
        it_should_behave_like "scores correctly", $phrasing_vectors["Bring back my bonnie to me"], incorrect_phrases
      end

      context "merge down to just two phrases" do
        incorrect_phrases = [ [ 0,                               33], [34,                               59] ]
        it_should_behave_like "scores correctly", $phrasing_vectors["Bring back my bonnie to me"], incorrect_phrases
      end
    end

    context "Bach Minuet in G" do
      context "merged some phrase pairs" do
        incorrect_phrases = [ [ 0, 15], [16, 25], [26, 31] ]
        it_should_behave_like "scores correctly", $phrasing_vectors["Bach Minuet in G"], incorrect_phrases
      end

      context "split first phrase" do
        incorrect_phrases = [ [ 0,  1], [ 2,  7], [ 8, 15], [16, 20], [21, 25], [26, 31] ]
        it_should_behave_like "scores correctly", $phrasing_vectors["Bach Minuet in G"], incorrect_phrases
      end

      context "split all phrases in half" do
        incorrect_phrases = [ [ 0,  3], [ 4,  7], [ 8, 11], [12, 15], [16, 18], [19, 20], [21, 22], [23, 25], [26, 28], [29, 31] ]
        it_should_behave_like "scores correctly", $phrasing_vectors["Bach Minuet in G"], incorrect_phrases
      end

      context "shifted all boundaries back by 1" do
        incorrect_phrases = [ [ 0,  8], [ 9, 16], [17, 21], [22, 26], [27, 31] ]
        it_should_behave_like "scores correctly", $phrasing_vectors["Bach Minuet in G"], incorrect_phrases
      end

      context "shifted all boundaries up by 1" do
        incorrect_phrases = [ [ 0,  6], [ 8, 14], [15, 19], [20, 24], [25, 31] ]
        it_should_behave_like "scores correctly", $phrasing_vectors["Bach Minuet in G"], incorrect_phrases
      end

      context "merged down to two near-uber phrases" do
        incorrect_phrases = [ [ 0, 13], [14, 31] ] 
        it_should_behave_like "scores correctly", $phrasing_vectors["Bach Minuet in G"], incorrect_phrases
      end

      context "shifted and merged" do
        incorrect_phrases = [ [ 0,  7], [ 8, 13], [14, 21], [22, 31] ]
        it_should_behave_like "scores correctly", $phrasing_vectors["Bach Minuet in G"], incorrect_phrases
      end
    end

    context "Battle hymn" do
      context "split 1st two phrases" do
        incorrect_phrases = [ [ 0,  6], [ 7, 13], [14, 20], [21, 28], [29, 43], [44, 49] ]
        it_should_behave_like "scores correctly", $phrasing_vectors["Battle hymn of the republic"], incorrect_phrases
      end

      context "uniform length but totally wrong" do
        incorrect_phrases = [ [ 0,  4], [ 5,  9], [10, 14], [15, 19], [20, 24], [25, 29], [30, 34], [35, 39], [40, 44], [45, 49] ]
        it_should_behave_like "scores correctly", $phrasing_vectors["Battle hymn of the republic"], incorrect_phrases
      end

      context "one long phrase" do
        incorrect_phrases = [ [ 0,  49] ]
        it_should_behave_like "scores correctly", $phrasing_vectors["Battle hymn of the republic"], incorrect_phrases
      end

      context "near miss", :known_fail=>true do
        incorrect_phrases = [ [ 0, 11], [12, 19], [20, 27], [28, 36], [37, 44], [45, 49] ]
        it_should_behave_like "scores correctly", $phrasing_vectors["Battle hymn of the republic"], incorrect_phrases
      end

      context "near miss (too few)" do
        incorrect_phrases = [ [ 0, 18], [19, 36], [37, 49] ]
        it_should_behave_like "scores correctly", $phrasing_vectors["Battle hymn of the republic"], incorrect_phrases
      end

      context "two near-uber phrases" do
        incorrect_phrases = [ [ 0, 27], [28, 49] ]
        it_should_behave_like "scores correctly", $phrasing_vectors["Battle hymn of the republic"], incorrect_phrases
      end
    end

    context "Somewhere over the rainbow" do
      context "near miss" do
        incorrect_phrases = [ [ 0,  6], [ 7,  9], [10, 21], [22, 22] ]
        it_should_behave_like "scores correctly", $phrasing_vectors["Somewhere over the rainbow"], incorrect_phrases
      end

      context "possible uber-phrases" do
        incorrect_phrases = [ [ 0,  9], [10, 22] ]
        it_should_behave_like "scores correctly", $phrasing_vectors["Somewhere over the rainbow"], incorrect_phrases
      end
    end

    context "Bach Minuet 2" do
      context "merged down to two uber phrases", :known_fail=>true do
        incorrect_phrases = [ [ 0,  11], [12, 26] ]
        it_should_behave_like "scores correctly", $phrasing_vectors["Bach Minuet (2)"], incorrect_phrases
      end

      context "merged, and off by one", :known_fail=>true do
        incorrect_phrases = [ [ 0,  7], [ 8, 16], [17, 26] ]
        it_should_behave_like "scores correctly", $phrasing_vectors["Bach Minuet (2)"], incorrect_phrases
      end
    end

    context "This train" do
      context "last phrase starts half-phrase early" do
        incorrect_phrases = [ [ 0,  8], [ 9, 17], [18, 32], [33, 45] ]
        it_should_behave_like "scores correctly", $phrasing_vectors["This train is bound for glory"], incorrect_phrases
      end
    end

 end

end
