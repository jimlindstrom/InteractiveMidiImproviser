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
    before(:all) do
      vector = $phrasing_vectors["Bring back my bonnie to me"]
      @nq = vector[:note_queue]
    end
    it "returns a float" do
      pl = Music::PhraseList.initial(@nq)
      pl.score.should be_an_instance_of Float
    end
  end

end
