#!/usr/bin/env ruby 

require 'spec_helper'

describe DurationAndBeatPositionCritic do
  before(:each) do
    @vector = $meter_vectors["Bring back my bonnie to me"]
    @nq1 = @vector[:note_queue]
    @nq1.detect_meter
    @nq1.tag_with_notes_left

    @vector = $meter_vectors["Battle hymn of the republic"]
    @nq2 = @vector[:note_queue]
    @nq2.detect_meter
    @nq2.tag_with_notes_left
  end

  context ".new" do
    it "should return a DurationAndBeatPositionCritic" do
      DurationAndBeatPositionCritic.new(order=1, lookahead=1).should be_an_instance_of DurationAndBeatPositionCritic
    end
  end

  context ".reset" do
    it "should reset to the state in which no notes have been heard yet" do
      dc = DurationAndBeatPositionCritic.new(order=1, lookahead=1)
      dc.listen(@nq1.first)
      dc.reset
      x = dc.get_expectations
      Music::Duration.new(x.choose_outcome).val.should == @nq1.first.duration.val
    end
  end

  context ".save" do
    it "should save a file, named <folder>/duration_and_beat_position_critic_<order>_<lookahead>.yml" do
      dc = DurationAndBeatPositionCritic.new(order=1, lookahead=1)
      dc.listen(@nq1.first)
      dc.listen(@nq2.first)
      filename = "data/test/duration_and_beat_position_critic_#{order}_#{lookahead}.yml"
      File.delete filename if FileTest.exists? filename
      dc.save "data/test"
      FileTest.exists?(filename).should == true
    end
  end

  context ".load" do
    it "should load a file, named <folder>/duration_and_beat_position_critic_<order>_<lookahead>.yml, and act just like the saved critic" do
      dc = DurationAndBeatPositionCritic.new(order=1, lookahead=1)
      dc.listen(@nq1[0])
      dc.listen(@nq1[1])
      dc.listen(@nq1[2])
      dc.reset
      dc.listen(@nq1[0])
      dc.listen(@nq1[1])
      dc.save "data/test"
      dc2 = DurationAndBeatPositionCritic.new(order=1, lookahead=1)
      dc2.load "data/test"
      x = dc.get_expectations
      x2 = dc2.get_expectations
      x.choose_outcome.should == x2.choose_outcome
    end
  end

  context ".cumulative_surprise" do
    it "should return zero initially" do
      dc = DurationAndBeatPositionCritic.new(order=1, lookahead=1)
      dc.cumulative_surprise.should be_within(0.0001).of(0.0)
    end
    it "should return the sum of all listening surprise" do
      dc = DurationAndBeatPositionCritic.new(order=1, lookahead=1)
      cum_surprise = 0.0
      cum_surprise += dc.listen(@nq1[0])
      cum_surprise += dc.listen(@nq1[1])
      cum_surprise += dc.listen(@nq1[2])
      cum_surprise += dc.listen(@nq1[3])
      dc.cumulative_surprise.should be_within(0.0001).of(cum_surprise)
    end
    it "should return zero after calling reset_cumulative_surprise" do
      dc = DurationAndBeatPositionCritic.new(order=1, lookahead=1)
      dc.listen(@nq1[0])
      dc.reset_cumulative_surprise
      dc.cumulative_surprise.should be_within(0.0001).of(0.0)
    end
  end

  context ".listen" do
    it "should raise an error if the note has no meter analysis" do
      dc = DurationAndBeatPositionCritic.new(order=1, lookahead=1)
      note = Music::Note.new(Music::Pitch.new(0), Music::Duration.new(1))
      note.analysis[:beat_position] = @nq1.first.analysis[:beat_position].dup
      #note.analysis[:notes_left] = 1
      expect{ dc.listen(note) }.to raise_error(ArgumentError)
    end
    it "should raise an error if the note isn't tagged with the number of following notes" do
      dc = DurationAndBeatPositionCritic.new(order=1, lookahead=1)
      note = Music::Note.new(Music::Pitch.new(0), Music::Duration.new(1))
      #note.analysis[:beat_position] = @nq1.first.analysis[:beat_position].dup
      note.analysis[:notes_left] = 1
      expect{ dc.listen(note) }.to raise_error(ArgumentError)
    end
    it "should return the surprise associated with the given note" do
      dc = DurationAndBeatPositionCritic.new(order=1, lookahead=1)
      note = Music::Note.new(Music::Pitch.new(0), Music::Duration.new(1))
      note.analysis[:beat_position] = @nq1.first.analysis[:beat_position].dup
      note.analysis[:notes_left] = 1
      surprise = dc.listen(note)
      surprise.should be_within(0.01).of(0.5)
    end
  end

  context ".get_expectations" do
    it "returns a random variable" do
      dc = DurationAndBeatPositionCritic.new(order=1, lookahead=1)
      dc.get_expectations.should be_an_instance_of Math::RandomVariable
    end
    it "returns a random variable that is less surprised about states observed more often" do
      dc = DurationAndBeatPositionCritic.new(order=1, lookahead=1)
      dc.listen(@nq1[0])
      dc.reset
      dc.listen(@nq1[0])
      dc.reset
      dc.listen(@nq2[1])
      dc.reset
      x = dc.get_expectations

      puts "x: " + x.inspect
      x.get_surprise(@nq1[0].duration.val).should be < x.get_surprise(@nq2[1].duration.val)
    end
    it "returns a random variable that only chooses states observed" do
      dc = DurationAndBeatPositionCritic.new(order=1, lookahead=1)
      dc.listen(@nq1.first)
      dc.reset
      x = dc.get_expectations
      Music::Duration.new(x.choose_outcome).val.should == 1
    end
  end

end
