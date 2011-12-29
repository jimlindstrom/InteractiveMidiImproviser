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
    it "should return the information_content associated with the given note" do
      order = 1
      pc = PitchCritic.new(order)
	  information_content = pc.listen(Music::Note.new(Music::Pitch.new(1), Music::Duration.new(0)))
	  information_content.should == Math::RandomVariable.max_information_content
	end
	it "should be less surprised the second time it hears a sequence" do
      pc = PitchCritic.new(order=2)
      pc.listen(Music::Note.new(Music::Pitch.new(71), Music::Duration.new(1)))
      orig_surprise = pc.listen(Music::Note.new(Music::Pitch.new(73), Music::Duration.new(1)))
      pc = PitchCritic.new(order=2)
      pitches = [64, 71, 71, 69, 76, 74, 73, 71, 74, 73, 71, 73, 74, 73, 71, 73, 71] #, 73
      pitches.each do |p|
        pc.listen(Music::Note.new(Music::Pitch.new(p), Music::Duration.new(1)))
      end
      new_surprise = pc.listen(Music::Note.new(Music::Pitch.new(73), Music::Duration.new(1)))
      new_surprise.should < orig_surprise
    end
  end

  context ".save" do
    it "should save a file, named <folder>/pitch_critic_<order>.yml" do
      order = 1
      pc = PitchCritic.new(order)
      information_content = pc.listen(Music::Note.new(Music::Pitch.new(1), Music::Duration.new(0)))
      filename = "data/test/pitch_critic_#{order}.yml"
      File.delete filename if FileTest.exists? filename
      pc.save "data/test"
      FileTest.exists?(filename).should == true
    end
  end

  context ".load" do
    it "should load a file, named <folder>/pitch_critic_<order>.yml, and act just like the saved critic" do
      order = 1
      pc = PitchCritic.new(order)
      pc.listen(Music::Note.new(Music::Pitch.new(1), Music::Duration.new(1)))
      pc.listen(Music::Note.new(Music::Pitch.new(2), Music::Duration.new(2)))
      pc.listen(Music::Note.new(Music::Pitch.new(3), Music::Duration.new(3)))
      pc.reset
      pc.listen(Music::Note.new(Music::Pitch.new(2), Music::Duration.new(2)))
      pc.save "data/test"
      pc2 = PitchCritic.new(order)
      pc2.load "data/test"
      x = pc2.get_expectations
      Music::Pitch.new(x.choose_outcome).val.should == 3
    end
  end

  context ".cumulative_information_content" do
    it "should return zero initially" do
      order = 1
      pc = PitchCritic.new(order)
      pc.cumulative_information_content.should be_within(0.0001).of(0.0)
    end
    it "should return the sum of all listening information_content" do
      order = 1
      pc = PitchCritic.new(order)
      cum_information_content = 0.0
      cum_information_content += pc.listen(Music::Note.new(Music::Pitch.new(1), Music::Duration.new(1)))
      cum_information_content += pc.listen(Music::Note.new(Music::Pitch.new(2), Music::Duration.new(3)))
      cum_information_content += pc.listen(Music::Note.new(Music::Pitch.new(4), Music::Duration.new(2)))
      cum_information_content += pc.listen(Music::Note.new(Music::Pitch.new(3), Music::Duration.new(2)))
      pc.cumulative_information_content.should be_within(0.0001).of(cum_information_content)
    end

    it "should return zero after calling reset_cumulative_information_content" do
      order = 1
      pc = PitchCritic.new(order)
      pc.listen(Music::Note.new(Music::Pitch.new(1), Music::Duration.new(1)))
      pc.reset_cumulative_information_content
      pc.cumulative_information_content.should be_within(0.0001).of(0.0)
    end
  end

  context ".get_expectations" do
    it "returns a random variable" do
      order = 1
      pc = PitchCritic.new(order)
      pc.get_expectations.should be_an_instance_of Math::RandomVariable
    end
    it "returns a random variable that is less information_contentd about states observed more often" do
      order = 1
      pc = PitchCritic.new(order)
      pc.listen(Music::Note.new(Music::Pitch.new(1), Music::Duration.new(0)))
      pc.reset
      pc.listen(Music::Note.new(Music::Pitch.new(1), Music::Duration.new(0)))
      pc.reset
      pc.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(0)))
      pc.reset
      x = pc.get_expectations
      x.information_content(1).should be < x.information_content(0)
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
      order = 3
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
