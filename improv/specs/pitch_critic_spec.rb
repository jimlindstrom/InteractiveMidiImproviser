#!/usr/bin/env ruby

require 'spec_helper'

describe PitchCritic do
  before do
  end

  context ".new" do
    it "should return a PitchCritic" do
      order = 1
      PitchCritic.new(order).should be_an_instance_of PitchCritic
    end
  end

  context ".reset" do
    it "should reset to the state in which no notes have been heard yet" do
      order = 1
      pc = PitchCritic.new(order)
      pc.listen(Music::Note.new(Music::Pitch.new(1), Music::Duration.new(0)))
      pc.reset
      x = pc.get_expectations
      Music::Pitch.new(x.choose_outcome).val.should == 1
    end
  end

  context ".listen" do
    it "should return the surprise associated with the given note" do
      order = 1
      pc = PitchCritic.new(order)
      surprise = pc.listen(Music::Note.new(Music::Pitch.new(1), Music::Duration.new(0)))
      surprise.should be_within(0.01).of(0.5)
    end
  end

  context ".save" do
    it "should save a file, named <folder>/pitch_critic_<order>.yml" do
      order = 1
      pc = PitchCritic.new(order)
      surprise = pc.listen(Music::Note.new(Music::Pitch.new(1), Music::Duration.new(0)))
      pc.save "data/test"
      FileTest.exists?("data/test/pitch_critic_#{order}.yml").should == true
    end
  end

  context ".get_expectations" do
    it "returns a random variable" do
      order = 1
      pc = PitchCritic.new(order)
      pc.get_expectations.should be_an_instance_of Math::RandomVariable
    end
    it "returns a random variable that is less surprised about states observed more often" do
      order = 1
      pc = PitchCritic.new(order)
      pc.listen(Music::Note.new(Music::Pitch.new(1), Music::Duration.new(0)))
      pc.reset
      pc.listen(Music::Note.new(Music::Pitch.new(1), Music::Duration.new(0)))
      pc.reset
      pc.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(0)))
      pc.reset
      x = pc.get_expectations
      x.get_surprise(1).should be < x.get_surprise(0)
    end
    it "returns a random variable that only chooses states observed" do
      order = 1
      pc = PitchCritic.new(order)
      pc.listen(Music::Note.new(Music::Pitch.new(1), Music::Duration.new(0)))
      pc.reset
      x = pc.get_expectations
      Music::Pitch.new(x.choose_outcome).val.should == 1
    end
    it "returns a random variable that only chooses states observed (higher order)" do
      order = 2
      pc = PitchCritic.new(order)
      pc.listen(Music::Note.new(Music::Pitch.new(1), Music::Duration.new(0)))
      pc.listen(Music::Note.new(Music::Pitch.new(2), Music::Duration.new(0)))
      pc.listen(Music::Note.new(Music::Pitch.new(3), Music::Duration.new(0)))
      pc.listen(Music::Note.new(Music::Pitch.new(6), Music::Duration.new(0)))
      pc.reset
      pc.listen(Music::Note.new(Music::Pitch.new(5), Music::Duration.new(0)))
      pc.listen(Music::Note.new(Music::Pitch.new(2), Music::Duration.new(0)))
      pc.listen(Music::Note.new(Music::Pitch.new(3), Music::Duration.new(0)))
      pc.listen(Music::Note.new(Music::Pitch.new(4), Music::Duration.new(0)))
      pc.reset
      pc.listen(Music::Note.new(Music::Pitch.new(5), Music::Duration.new(0)))
      pc.listen(Music::Note.new(Music::Pitch.new(2), Music::Duration.new(0)))
      pc.listen(Music::Note.new(Music::Pitch.new(3), Music::Duration.new(0)))
      x = pc.get_expectations
      Music::Pitch.new(x.choose_outcome).val.should == 4
    end
  end


end
