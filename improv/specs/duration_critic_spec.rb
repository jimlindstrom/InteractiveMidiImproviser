#!/usr/bin/env ruby 

require 'spec_helper'

describe DurationCritic do
  before do
  end

  context ".new" do
    it "should return a DurationCritic" do
      order = 1
      DurationCritic.new(order).should be_an_instance_of DurationCritic
    end
  end

  context ".reset" do
    it "should reset to the state in which no notes have been heard yet" do
      order = 1
      dc = DurationCritic.new(order)
      dc.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(1)))
      dc.reset
      x = dc.get_expectations
      Music::Duration.new(x.choose_outcome).val.should == 1
    end
  end

  context ".save" do
    it "should save a file, named <folder>/duration_critic_<order>.yml" do
      order = 1
      dc = DurationCritic.new(order)
      dc.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(2)))
      dc.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(1)))
      filename = "data/test/duration_critic_#{order}.yml"
      File.delete filename if FileTest.exists? filename
      dc.save "data/test"
      FileTest.exists?(filename).should == true
    end
  end

  context ".cumulative_surprise" do
    it "should return zero initially" do
      order = 1
      dc = DurationCritic.new(order)
      dc.cumulative_surprise.should be_within(0.0001).of(0.0)
    end
    it "should return the sum of all listening surprise" do
      order = 1
      dc = DurationCritic.new(order)
      cum_surprise = 0.0
      cum_surprise += dc.listen(Music::Note.new(Music::Pitch.new(1), Music::Duration.new(1)))
      cum_surprise += dc.listen(Music::Note.new(Music::Pitch.new(2), Music::Duration.new(3)))
      cum_surprise += dc.listen(Music::Note.new(Music::Pitch.new(4), Music::Duration.new(2)))
      cum_surprise += dc.listen(Music::Note.new(Music::Pitch.new(3), Music::Duration.new(2)))
      dc.cumulative_surprise.should be_within(0.0001).of(cum_surprise)
    end
    it "should return zero after calling reset_cumulative_surprise" do
      order = 1
      dc = DurationCritic.new(order)
      dc.listen(Music::Note.new(Music::Pitch.new(1), Music::Duration.new(1)))
      dc.reset_cumulative_surprise
      dc.cumulative_surprise.should be_within(0.0001).of(0.0)
    end
  end
  context ".listen" do
    it "should return the surprise associated with the given note" do
      order = 1
      dc = DurationCritic.new(order)
      surprise = dc.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(1)))
      surprise.should be_within(0.01).of(0.5)
    end
  end

  context ".get_expectations" do
    it "returns a random variable" do
      order = 1
      dc = DurationCritic.new(order)
      dc.get_expectations.should be_an_instance_of Math::RandomVariable
    end
    it "returns a random variable that is less surprised about states observed more often" do
      order = 1
      dc = DurationCritic.new(order)
      dc.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(1)))
      dc.reset
      dc.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(1)))
      dc.reset
      dc.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(0)))
      dc.reset
      x = dc.get_expectations
      x.get_surprise(1).should be < x.get_surprise(0)
    end
    it "returns a random variable that only chooses states observed" do
      order = 1
      dc = DurationCritic.new(order)
      dc.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(1)))
      dc.reset
      x = dc.get_expectations
      Music::Duration.new(x.choose_outcome).val.should == 1
    end
    it "returns a random variable that only chooses states observed (higher order)" do
      order = 2
      dc = DurationCritic.new(order)
      dc.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(1)))
      dc.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(2)))
      dc.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(3)))
      dc.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(6)))
      dc.reset
      dc.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(5)))
      dc.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(2)))
      dc.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(3)))
      dc.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(4)))
      dc.reset
      dc.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(5)))
      dc.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(2)))
      dc.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(3)))
      x = dc.get_expectations
      Music::Duration.new(x.choose_outcome).val.should == 4
    end
  end


end
