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
      dc.listen(Note.new(Pitch.new(0), Duration.new(1)))
      dc.reset
      x = dc.get_expectations
      Duration.new(x.choose_outcome).val.should be 1
    end
  end

  context ".listen" do
    it "should return the surprise associated with the given note" do
      order = 1
      dc = DurationCritic.new(order)
      surprise = dc.listen(Note.new(Pitch.new(0), Duration.new(1)))
      surprise.should be_within(0.01).of(0.5)
    end
  end

  context ".get_expectations" do
    it "returns a random variable" do
      order = 1
      dc = DurationCritic.new(order)
      dc.get_expectations.should be_an_instance_of RandomVariable
    end
    it "returns a random variable that is less surprised about states observed more often" do
      order = 1
      dc = DurationCritic.new(order)
      dc.listen(Note.new(Pitch.new(0), Duration.new(1)))
      dc.reset
      dc.listen(Note.new(Pitch.new(0), Duration.new(1)))
      dc.reset
      dc.listen(Note.new(Pitch.new(0), Duration.new(0)))
      dc.reset
      x = dc.get_expectations
      x.get_surprise(1).should be < x.get_surprise(0)
    end
    it "returns a random variable that only chooses states observed" do
      order = 1
      dc = DurationCritic.new(order)
      dc.listen(Note.new(Pitch.new(0), Duration.new(1)))
      dc.reset
      x = dc.get_expectations
      Duration.new(x.choose_outcome).val.should be 1
    end
    it "returns a random variable that only chooses states observed (higher order)" do
      order = 2
      dc = DurationCritic.new(order)
      dc.listen(Note.new(Pitch.new(0), Duration.new(1)))
      dc.listen(Note.new(Pitch.new(0), Duration.new(2)))
      dc.listen(Note.new(Pitch.new(0), Duration.new(3)))
      dc.listen(Note.new(Pitch.new(0), Duration.new(6)))
      dc.reset
      dc.listen(Note.new(Pitch.new(0), Duration.new(5)))
      dc.listen(Note.new(Pitch.new(0), Duration.new(2)))
      dc.listen(Note.new(Pitch.new(0), Duration.new(3)))
      dc.listen(Note.new(Pitch.new(0), Duration.new(4)))
      dc.reset
      dc.listen(Note.new(Pitch.new(0), Duration.new(5)))
      dc.listen(Note.new(Pitch.new(0), Duration.new(2)))
      dc.listen(Note.new(Pitch.new(0), Duration.new(3)))
      x = dc.get_expectations
      Duration.new(x.choose_outcome).val.should be 4
    end
  end


end