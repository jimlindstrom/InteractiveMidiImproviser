#!/usr/bin/env ruby 

require 'spec_helper'

describe Music::Phrase do
  before do
  end

  context "new" do
    it "should take a note queue, a start (note) index and an end (note) index" do
      vector = $phrasing_vectors["Bring back my bonnie to me"]
      nq = vector[:note_queue]
      Music::Phrase.new(nq, idx1=2, idx2=8).should be_an_instance_of Music::Phrase
    end
    it "should raise an error if the indices are out of bounds" do
      vector = $phrasing_vectors["Bring back my bonnie to me"]
      nq = vector[:note_queue]
      expect { Music::Phrase.new(nq, idx1=-1, idx2=8) }.to raise_error
    end
    it "should raise an error if the indices are out of bounds" do
      vector = $phrasing_vectors["Bring back my bonnie to me"]
      nq = vector[:note_queue]
      expect { Music::Phrase.new(nq, idx1=1, idx2=nq.length) }.to raise_error
    end
    it "should raise an error if the indices are out of order" do
      vector = $phrasing_vectors["Bring back my bonnie to me"]
      nq = vector[:note_queue]
      expect { Music::Phrase.new(nq, idx1=5, idx2=3) }.to raise_error
    end
  end

  context "notes" do
    before(:all) do
      vector = $phrasing_vectors["Bring back my bonnie to me"]
      @nq = vector[:note_queue]
      @p = Music::Phrase.new(@nq, @idx1=2, @idx2=8)
    end
    it "should return a note_queue" do
      @p.notes.should be_an_instance_of Music::NoteQueue
    end
    it "should return the notes included in this phrase" do
      expected_notes = @nq[@idx1..@idx2].collect{ |n| [ n.pitch.val, n.duration.val ] }
      @p.notes.collect{ |n| [ n.pitch.val, n.duration.val ] }.should == expected_notes
    end
  end

  context "duration" do
    before(:all) do
      vector = $phrasing_vectors["Bring back my bonnie to me"]
      @nq = vector[:note_queue]
      @p = Music::Phrase.new(@nq, @idx1=2, @idx2=8)
    end
    it "should return the sum of the duration of the individual notes" do
      expected_duration = @nq[@idx1..@idx2].inject(0.0){ |x,s| x + s.duration.val }
      @p.duration.should == expected_duration
    end
  end

  context "length" do
    before(:all) do
      vector = $phrasing_vectors["Bring back my bonnie to me"]
      @nq = vector[:note_queue]
      @p = Music::Phrase.new(@nq, @idx1=2, @idx2=8)
    end
    it "should return the number of individual notes" do
      expected_length = Array(@idx1..@idx2).length
      @p.length.should == expected_length
    end
  end

  context "score" do
    before(:all) do
      vector = $phrasing_vectors["Bring back my bonnie to me"]
      @nq = vector[:note_queue]
      @p = Music::Phrase.new(@nq, @idx1=2, @idx2=8)
    end
    it "should return a floating point value" do
      @p.score.should be_an_instance_of Float
    end
  end

end
