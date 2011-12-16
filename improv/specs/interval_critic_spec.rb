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

      base_note = (rand*50).floor + 25
      interval  = (rand*10).floor - 10
      ic.listen(Music::Note.new(Music::Pitch.new(base_note),            Music::Duration.new(0)))
      ic.listen(Music::Note.new(Music::Pitch.new(base_note + interval), Music::Duration.new(0)))
      ic.reset

      base_note = (rand*50).floor + 25
      ic.listen(Music::Note.new(Music::Pitch.new(base_note), Music::Duration.new(0)))
      x = ic.get_expectations
      Music::Pitch.new(x.choose_outcome).val.should == (base_note + interval)
    end
  end

  context ".save" do
    it "should save a file, named <folder>/interval_critic_<order>.yml" do
      order = 1
      ic = IntervalCritic.new(order)
      ic.listen(Music::Note.new(Music::Pitch.new(4), Music::Duration.new(1)))
      ic.listen(Music::Note.new(Music::Pitch.new(2), Music::Duration.new(1)))
      ic.listen(Music::Note.new(Music::Pitch.new(4), Music::Duration.new(1)))
      ic.listen(Music::Note.new(Music::Pitch.new(2), Music::Duration.new(1)))
      filename = "data/test/interval_critic_#{order}.yml"
      File.delete filename if FileTest.exists? filename
      ic.save "data/test"
      FileTest.exists?(filename).should == true
    end
  end

  context ".listen" do
    it "should return nil if zero or one notes have been heard" do
      order = 1
      ic = IntervalCritic.new(order)
      surprise = ic.listen(Music::Note.new(Music::Pitch.new(1), Music::Duration.new(0)))
      surprise.should be nil
    end
    it "should return the surprise associated with the given note" do
      order = 1
      ic = IntervalCritic.new(order)
      ic.listen(Music::Note.new(Music::Pitch.new(1), Music::Duration.new(0)))
      surprise = ic.listen(Music::Note.new(Music::Pitch.new(1), Music::Duration.new(0)))
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
      ic.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(0)))
      ic.get_expectations.should be_an_instance_of Math::RandomVariable
    end
    it "returns a random variable that is less surprised about states observed more often" do
      order = 1
      ic = IntervalCritic.new(order)
      ic.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(0)))
      ic.listen(Music::Note.new(Music::Pitch.new(1), Music::Duration.new(0)))
      ic.reset
      ic.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(0)))
      ic.listen(Music::Note.new(Music::Pitch.new(1), Music::Duration.new(0)))
      ic.reset
      ic.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(0)))
      ic.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(0)))
      ic.reset
      ic.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(0)))
      x = ic.get_expectations
      x.get_surprise(Music::Pitch.new(1).val).should be < x.get_surprise(Music::Pitch.new(0).val)
    end
    it "returns a random variable that only chooses states observed" do
      order = 1
      ic = IntervalCritic.new(order)

      base_note = (rand*50).floor + 25
      interval  = (rand*10).floor - 5
      ic.listen(Music::Note.new(Music::Pitch.new(base_note),            Music::Duration.new(0)))
      ic.listen(Music::Note.new(Music::Pitch.new(base_note + interval), Music::Duration.new(0)))
      ic.reset

      base_note = (rand*50).floor + 25
      ic.listen(Music::Note.new(Music::Pitch.new(base_note), Music::Duration.new(0)))

      x = ic.get_expectations
      Music::Pitch.new(x.choose_outcome).val.should == (base_note + interval)
    end
    it "returns a random variable that only chooses states observed (higher order)" do
      order = 2
      ic = IntervalCritic.new(order)
      ic.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(0)))
      ic.listen(Music::Note.new(Music::Pitch.new(1), Music::Duration.new(0))) # 1
      ic.listen(Music::Note.new(Music::Pitch.new(2), Music::Duration.new(0))) # 1
      ic.listen(Music::Note.new(Music::Pitch.new(3), Music::Duration.new(0))) # 1
      ic.listen(Music::Note.new(Music::Pitch.new(6), Music::Duration.new(0))) # 3
      ic.reset
      ic.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(0)))
      ic.listen(Music::Note.new(Music::Pitch.new(5), Music::Duration.new(0))) # 5
      ic.listen(Music::Note.new(Music::Pitch.new(6), Music::Duration.new(0))) # 1
      ic.listen(Music::Note.new(Music::Pitch.new(7), Music::Duration.new(0))) # 1
      ic.listen(Music::Note.new(Music::Pitch.new(8), Music::Duration.new(0))) # 1
      ic.reset
      ic.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(0)))
      ic.listen(Music::Note.new(Music::Pitch.new(5), Music::Duration.new(0))) # 5
      ic.listen(Music::Note.new(Music::Pitch.new(6), Music::Duration.new(0))) # 1
      ic.listen(Music::Note.new(Music::Pitch.new(7), Music::Duration.new(0))) # 1
      x = ic.get_expectations
      last_note = 7
      expected_interval = 1
      Music::Pitch.new(x.choose_outcome).val.should == (last_note + expected_interval)
    end
  end


end
