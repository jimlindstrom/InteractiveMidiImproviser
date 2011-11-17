#!/usr/bin/env ruby 

require 'spec_helper'

describe IntervalCritic do
  before do
  end

  context ".new" do
    it "should return a IntervalCritic" do
      order = 1
      IntervalCritic.new(order).should be_an_instance_of IntervalCritic
    end
  end

  context ".reset" do
    it "should reset to the state in which no notes have been heard yet" do
      order = 1
      ic = IntervalCritic.new(order)
      ic.listen(Note.new(Pitch.new(0), Duration.new(0)))
      ic.listen(Note.new(Pitch.new(1), Duration.new(0)))
      ic.reset
      ic.listen(Note.new(Pitch.new(1), Duration.new(0)))
      x = ic.get_expectations
      Interval.new(x.choose_outcome).val.should == 1
    end
  end

  context ".listen" do
    it "should return nil if zero or one notes have been heard" do
      order = 1
      ic = IntervalCritic.new(order)
      surprise = ic.listen(Note.new(Pitch.new(1), Duration.new(0)))
      surprise.should be nil
    end
    it "should return the surprise associated with the given note" do
      order = 1
      ic = IntervalCritic.new(order)
      ic.listen(Note.new(Pitch.new(1), Duration.new(0)))
      surprise = ic.listen(Note.new(Pitch.new(1), Duration.new(0)))
      surprise.should be_within(0.01).of(0.5)
    end
  end

  context ".get_expectations" do
    it "returns nil until one note has been listened to" do
      order = 1
      ic = IntervalCritic.new(order)
      ic.get_expectations.should be_nil
    end
    it "returns a random variable" do
      order = 1
      ic = IntervalCritic.new(order)
      ic.listen(Note.new(Pitch.new(0), Duration.new(0)))
      ic.get_expectations.should be_an_instance_of RandomVariable
    end
    it "returns a random variable that is less surprised about states observed more often" do
      order = 1
      ic = IntervalCritic.new(order)
      ic.listen(Note.new(Pitch.new(0), Duration.new(0)))
      ic.listen(Note.new(Pitch.new(1), Duration.new(0)))
      ic.reset
      ic.listen(Note.new(Pitch.new(0), Duration.new(0)))
      ic.listen(Note.new(Pitch.new(1), Duration.new(0)))
      ic.reset
      ic.listen(Note.new(Pitch.new(0), Duration.new(0)))
      ic.listen(Note.new(Pitch.new(0), Duration.new(0)))
      ic.reset
      ic.listen(Note.new(Pitch.new(0), Duration.new(0)))
      x = ic.get_expectations
      x.get_surprise(Interval.new(1).val).should be < x.get_surprise(Interval.new(0).val)
    end
    it "returns a random variable that only chooses states observed" do
      order = 1
      ic = IntervalCritic.new(order)
      ic.listen(Note.new(Pitch.new(0), Duration.new(0)))
      ic.listen(Note.new(Pitch.new(1), Duration.new(0)))
      ic.reset
      ic.listen(Note.new(Pitch.new(1), Duration.new(0)))
      x = ic.get_expectations
      Interval.new(x.choose_outcome).val.should == Interval.new(1).val
    end
    it "returns a random variable that only chooses states observed (higher order)" do
      order = 2
      ic = IntervalCritic.new(order)
      ic.listen(Note.new(Pitch.new(0), Duration.new(0)))
      ic.listen(Note.new(Pitch.new(1), Duration.new(0))) # 1
      ic.listen(Note.new(Pitch.new(2), Duration.new(0))) # 1
      ic.listen(Note.new(Pitch.new(3), Duration.new(0))) # 1
      ic.listen(Note.new(Pitch.new(6), Duration.new(0))) # 3
      ic.reset
      ic.listen(Note.new(Pitch.new(0), Duration.new(0)))
      ic.listen(Note.new(Pitch.new(5), Duration.new(0))) # 5
      ic.listen(Note.new(Pitch.new(6), Duration.new(0))) # 1
      ic.listen(Note.new(Pitch.new(7), Duration.new(0))) # 1
      ic.listen(Note.new(Pitch.new(8), Duration.new(0))) # 1
      ic.reset
      ic.listen(Note.new(Pitch.new(0), Duration.new(0)))
      ic.listen(Note.new(Pitch.new(5), Duration.new(0))) # 5
      ic.listen(Note.new(Pitch.new(6), Duration.new(0))) # 1
      ic.listen(Note.new(Pitch.new(7), Duration.new(0))) # 1
      x = ic.get_expectations
      Interval.new(x.choose_outcome).val.should == Interval.new(1).val
    end
  end


end
