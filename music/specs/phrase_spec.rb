#!/usr/bin/env ruby 

require 'spec_helper'

describe Music::Phrase do
  before(:each) do
    @vector = $phrasing_vectors["Bring back my bonnie to me"]
    @nq = @vector[:note_queue]
  end

  describe ".new" do
    it "should take a note queue, a start (note) index and an end (note) index" do
      Music::Phrase.new(@nq, idx1=2, idx2=8).should be_an_instance_of Music::Phrase
    end
    it "should raise an error if the indices are out of bounds" do
      expect { Music::Phrase.new(@nq, idx1=-1, idx2=8) }.to raise_error
    end
    it "should raise an error if the indices are out of bounds" do
      expect { Music::Phrase.new(@nq, idx1=1, idx2=nq.length) }.to raise_error
    end
    it "should raise an error if the indices are out of order" do
      expect { Music::Phrase.new(@nq, idx1=5, idx2=3) }.to raise_error
    end
  end

  describe ".notes" do
    before(:each) do
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

  describe ".duration" do
    before(:each) do
      @p = Music::Phrase.new(@nq, @idx1=2, @idx2=8)
    end
    it "should return the sum of the duration of the individual notes" do
      expected_duration = @nq[@idx1..@idx2].inject(0.0){ |x,s| x + s.duration.val }
      @p.duration.should == expected_duration
    end
  end

  describe ".length" do
    before(:each) do
      @p = Music::Phrase.new(@nq, @idx1=2, @idx2=8)
    end
    it "should return the number of individual notes" do
      expected_length = Array(@idx1..@idx2).length
      @p.length.should == expected_length
    end
  end

  describe ".score" do
    before(:each) do
      @nq.analyze!
      @p = Music::Phrase.new(@nq, @idx1=2, @idx2=8)
    end
    it "should return a floating point value" do
      @p.score.should be_an_instance_of Float
    end
  end

  describe ".split_at_a_big_interval" do
    before(:each) do
      @nq.analyze!
    end
    context "for phrases with 0 or 1 notes" do
      it "should raise an error" do
        @one_note_phrase = Music::Phrase.new(@nq, idx1=2, idx2=2)
        expect { @one_note_phrase.split_at_a_big_interval }.to raise_error
      end
    end
    context "for phrases with 2 or more notes" do
      before(:each) do
        @two_note_phrase = Music::Phrase.new(@nq, idx1=2, idx2=3)
        @six_note_phrase = Music::Phrase.new(@nq, idx1=2, idx2=7)
      end
      it "should return a new phrase" do
        @two_note_phrase.split_at_a_big_interval.should be_an_instance_of Music::Phrase
      end
      it "should decrement its own ending index by at least 1" do
        old_end_idx = @two_note_phrase.end_idx
        @two_note_phrase.split_at_a_big_interval
        @two_note_phrase.end_idx.should be < old_end_idx
      end
      it "should return a new phrase starting right after the newly-split current phrase" do
        p2 = @six_note_phrase.split_at_a_big_interval
        @six_note_phrase.end_idx.should == (p2.start_idx-1)
      end
      it "should return a new phrase ending at the end of the original phrase" do
        old_end_idx = @six_note_phrase.end_idx
        p2 = @six_note_phrase.split_at_a_big_interval
        p2.end_idx.should == old_end_idx
      end
    end
  end

end
