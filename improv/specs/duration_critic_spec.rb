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

  context ".load" do
    it "should load a file, named <folder>/duration_critic_<order>.yml, and act just like the saved critic" do
      order = 1
      dc = DurationCritic.new(order)
      dc.listen(Music::Note.new(Music::Pitch.new(1), Music::Duration.new(1)))
      dc.listen(Music::Note.new(Music::Pitch.new(2), Music::Duration.new(2)))
      dc.listen(Music::Note.new(Music::Pitch.new(3), Music::Duration.new(3)))
      dc.reset
      dc.listen(Music::Note.new(Music::Pitch.new(2), Music::Duration.new(2)))
      dc.save "data/test"
      dc2 = DurationCritic.new(order)
      dc2.load "data/test"
      x = dc.get_expectations
      x2 = dc2.get_expectations
      x.choose_outcome.should == x2.choose_outcome
    end
  end

  context ".cumulative_information_content" do
    it "should return zero initially" do
      order = 1
      dc = DurationCritic.new(order)
      dc.cumulative_information_content.should be_within(0.0001).of(0.0)
    end
    it "should return the sum of all listening information_content" do
      order = 1
      dc = DurationCritic.new(order)
      cum_information_content = 0.0
      cum_information_content += dc.listen(Music::Note.new(Music::Pitch.new(1), Music::Duration.new(1)))
      cum_information_content += dc.listen(Music::Note.new(Music::Pitch.new(2), Music::Duration.new(3)))
      cum_information_content += dc.listen(Music::Note.new(Music::Pitch.new(4), Music::Duration.new(2)))
      cum_information_content += dc.listen(Music::Note.new(Music::Pitch.new(3), Music::Duration.new(2)))
      dc.cumulative_information_content.should be_within(0.0001).of(cum_information_content)
    end
    it "should return zero after calling reset_cumulative_information_content" do
      order = 1
      dc = DurationCritic.new(order)
      dc.listen(Music::Note.new(Music::Pitch.new(1), Music::Duration.new(1)))
      dc.reset_cumulative_information_content
      dc.cumulative_information_content.should be_within(0.0001).of(0.0)
    end
  end
  context ".listen" do
    it "should return the information_content associated with the given note" do
      order = 1
      dc = DurationCritic.new(order)
      information_content = dc.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(1)))
	  information_content.should == Math::RandomVariable.max_information_content
    end
  end

  context ".get_expectations" do
    it "returns a random variable" do
      order = 1
      dc = DurationCritic.new(order)
      dc.get_expectations.should be_an_instance_of Math::RandomVariable
    end
    it "returns a random variable that is less information_contentd about states observed more often" do
      order = 1
      dc = DurationCritic.new(order)
      dc.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(1)))
      dc.reset
      dc.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(1)))
      dc.reset
      dc.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(0)))
      dc.reset
      x = dc.get_expectations
      x.information_content(1).should be < x.information_content(0)
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
      order = 3
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
