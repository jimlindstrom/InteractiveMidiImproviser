#!/usr/bin/env ruby 

require 'spec_helper'

describe DurationAndBeatPositionCritic do
  before(:each) do
    @vector = $meter_vectors["Bring back my bonnie to me"]
    @nq1 = @vector[:note_queue]
    @nq1.detect_meter

    @vector = $meter_vectors["Battle hymn of the republic"]
    @nq2 = @vector[:note_queue]
    @nq2.detect_meter
  end

  context ".new" do
    it "should return a DurationAndBeatPositionCritic" do
      order = 1
      DurationAndBeatPositionCritic.new(order).should be_an_instance_of DurationAndBeatPositionCritic
    end
  end

  context ".reset" do
    it "should reset to the state in which no notes have been heard yet" do
      order = 1
      dc = DurationAndBeatPositionCritic.new(order)
      dc.listen(@nq1.first)
      dc.reset
      x = dc.get_expectations
      Music::DurationAndBeatPosition.new(*x.choose_outcome).duration.val.should == @nq1.first.duration.val
    end
  end

  context ".save" do
    it "should save a file, named <folder>/duration_and_beat_position_critic_<order>.yml" do
      order = 1
      dc = DurationAndBeatPositionCritic.new(order)
      dc.listen(@nq1.first)
      dc.listen(@nq2.first)
      filename = "data/test/duration_and_beat_position_critic_#{order}.yml"
      File.delete filename if FileTest.exists? filename
      dc.save "data/test"
      FileTest.exists?(filename).should == true
    end
  end

  context ".cumulative_surprise" do
    it "should return zero initially" do
      order = 1
      dc = DurationAndBeatPositionCritic.new(order)
      dc.cumulative_surprise.should be_within(0.0001).of(0.0)
    end
    it "should return the sum of all listening surprise" do
      order = 1
      dc = DurationAndBeatPositionCritic.new(order)
      cum_surprise = 0.0
      cum_surprise += dc.listen(@nq1[0])
      cum_surprise += dc.listen(@nq1[1])
      cum_surprise += dc.listen(@nq1[2])
      cum_surprise += dc.listen(@nq1[3])
      dc.cumulative_surprise.should be_within(0.0001).of(cum_surprise)
    end
    it "should return zero after calling reset_cumulative_surprise" do
      order = 1
      dc = DurationAndBeatPositionCritic.new(order)
      dc.listen(@nq1[0])
      dc.reset_cumulative_surprise
      dc.cumulative_surprise.should be_within(0.0001).of(0.0)
    end
  end

  context ".listen" do
    it "should raise an error if the note has no meter analysis" do
      order = 1
      dc = DurationAndBeatPositionCritic.new(order)
      expect{ dc.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(1))) }.to raise_error(ArgumentError)
    end
    it "should return the surprise associated with the given note" do
      order = 1
      dc = DurationAndBeatPositionCritic.new(order)
      surprise = dc.listen(@nq1.first)
      surprise.should be_within(0.01).of(0.5)
    end
  end

  context ".get_expectations" do
    it "returns a random variable" do
      order = 1
      dc = DurationAndBeatPositionCritic.new(order)
      dc.get_expectations.should be_an_instance_of Math::RandomVariable
    end
    it "returns a random variable that is less surprised about states observed more often" do
      order = 1
      dc = DurationAndBeatPositionCritic.new(order)
      dc.listen(@nq1.first)
      dc.reset
      dc.listen(@nq1.first)
      dc.reset
      dc.listen(@nq2.first)
      dc.reset
      x = dc.get_expectations

      dbps1 = Music::DurationAndBeatPosition.new(@nq1.first.duration, @nq1.first.analysis[:beat_position])
      dbps2 = Music::DurationAndBeatPosition.new(@nq2.first.duration, @nq2.first.analysis[:beat_position])

      x.get_surprise(dbps1.val).should be < x.get_surprise(dbps2.val)
    end
    it "returns a random variable that only chooses states observed" do
      order = 1
      dc = DurationAndBeatPositionCritic.new(order)
      dc.listen(@nq1.first)
      dc.reset
      x = dc.get_expectations
      Music::DurationAndBeatPosition.new(*x.choose_outcome).duration.val.should == 1
    end
  end

end
