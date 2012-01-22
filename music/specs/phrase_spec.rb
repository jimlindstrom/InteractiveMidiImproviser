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

  context "split_at_a_big_interval" do
    before(:each) do
      vector = $phrasing_vectors["Bring back my bonnie to me"]
      @nq = vector[:note_queue]
      @nq.create_intervals
    end
    it "should raise an error for phrases with fewer than two notes" do
      p = Music::Phrase.new(@nq, idx1=2, idx2=2)
      expect { p.split_at_a_big_interval }.to raise_error
    end
    it "should return a new phrase, for phrases containing two or more notes" do
      p = Music::Phrase.new(@nq, idx1=2, idx2=3)
      p.split_at_a_big_interval.should be_an_instance_of Music::Phrase
    end
    it "should decrement its own ending index by at least 1" do
      p = Music::Phrase.new(@nq, idx1=2, idx2=3)
      p.split_at_a_big_interval
      p.end_idx.should be < 3
    end
    it "should return a new phrase starting right after the newly-split current phrase" do
      p = Music::Phrase.new(@nq, idx1=2, idx2=7)
      p2 = p.split_at_a_big_interval
      p.end_idx.should == (p2.start_idx-1)
    end
    it "should return a new phrase ending at the end of the original phrase" do
      p = Music::Phrase.new(@nq, idx1=2, idx2=7)
      p2 = p.split_at_a_big_interval
      p2.end_idx.should == idx2
    end
  end


end
