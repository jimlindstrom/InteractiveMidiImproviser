#!/usr/bin/env ruby 

require 'spec_helper'

describe PitchAndPitchClassSetCritic do
  before(:each) do
    @vector = $meter_vectors["Bring back my bonnie to me"]
    @nq1 = @vector[:note_queue]

    @vector = $meter_vectors["Battle hymn of the republic"]
    @nq2 = @vector[:note_queue]
  end

  context ".new" do
    it "should return a PitchAndPitchClassSetCritic" do
      PitchAndPitchClassSetCritic.new(order=1).should be_an_instance_of PitchAndPitchClassSetCritic
    end
  end

  context ".reset" do
    it "should reset to the state in which no notes have been heard yet" do
      ppcs = PitchAndPitchClassSetCritic.new(order=1)
      ppcs.listen(@nq1.first)
      ppcs.reset
      x = ppcs.get_expectations
      Music::Pitch.new(x.choose_outcome).val.should == @nq1.first.pitch.val
    end
    it "should reset the current pitch class set" do
      ppcs = PitchAndPitchClassSetCritic.new(order=2)
      ppcs.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(2)))
      ppcs.listen(Music::Note.new(Music::Pitch.new(1), Music::Duration.new(2)))
      ppcs.listen(Music::Note.new(Music::Pitch.new(2), Music::Duration.new(2)))
      ppcs.listen(Music::Note.new(Music::Pitch.new(2), Music::Duration.new(2)))
      ppcs.reset
      ppcs.current_pitch_class_set.vals.should == []
    end

  end

  context ".save" do
    it "should save a file, named <folder>/pitch_and_pitch_class_set_critic_<order>.yml" do
      ppcs = PitchAndPitchClassSetCritic.new(order=1)
      ppcs.listen(@nq1.first)
      ppcs.listen(@nq2.first)
      filename = "data/test/pitch_and_pitch_class_set_critic_#{order}.yml"
      File.delete filename if FileTest.exists? filename
      ppcs.save "data/test"
      FileTest.exists?(filename).should == true
    end
  end

  context ".load" do
    it "should load a file, named <folder>/pitch_and_pitch_class_set_critic_<order>.yml, and act just like the saved critic" do
      ppcs = PitchAndPitchClassSetCritic.new(order=1)
      ppcs.listen(@nq1[0])
      ppcs.listen(@nq1[1])
      ppcs.listen(@nq1[2])
      ppcs.reset
      ppcs.listen(@nq1[0])
      ppcs.listen(@nq1[1])
      ppcs.save "data/test"
      ppcs2 = PitchAndPitchClassSetCritic.new(order=1)
      ppcs2.load "data/test"
      x = ppcs.get_expectations
      x2 = ppcs2.get_expectations
      x.choose_outcome.should == x2.choose_outcome
    end
  end

  context ".cumulative_surprise" do
    it "should return zero initially" do
      ppcs = PitchAndPitchClassSetCritic.new(order=1)
      ppcs.cumulative_surprise.should be_within(0.0001).of(0.0)
    end
    it "should return the sum of all listening surprise" do
      ppcs = PitchAndPitchClassSetCritic.new(order=1)
      cum_surprise = 0.0
      cum_surprise += ppcs.listen(@nq1[0])
      cum_surprise += ppcs.listen(@nq1[1])
      cum_surprise += ppcs.listen(@nq1[2])
      cum_surprise += ppcs.listen(@nq1[3])
      ppcs.cumulative_surprise.should be_within(0.0001).of(cum_surprise)
    end
    it "should return zero after calling reset_cumulative_surprise" do
      ppcs = PitchAndPitchClassSetCritic.new(order=1)
      ppcs.listen(@nq1[0])
      ppcs.reset_cumulative_surprise
      ppcs.cumulative_surprise.should be_within(0.0001).of(0.0)
    end
  end

  context ".listen" do
    it "should return the surprise associated with the given note" do
      ppcs = PitchAndPitchClassSetCritic.new(order=1)
      note = Music::Note.new(Music::Pitch.new(0), Music::Duration.new(1))
      surprise = ppcs.listen(note)
      surprise.should be_within(0.01).of(0.5)
    end
  end

  context ".get_expectations" do
    it "returns a random variable" do
      ppcs = PitchAndPitchClassSetCritic.new(order=1)
      ppcs.get_expectations.should be_an_instance_of Math::RandomVariable
    end
    it "returns a random variable that is less surprised about states observed more often" do
      ppcs = PitchAndPitchClassSetCritic.new(order=1)
      ppcs.listen(@nq1[0])
      ppcs.reset
      ppcs.listen(@nq1[0])
      ppcs.reset
      ppcs.listen(@nq1[1])
      ppcs.reset
      x = ppcs.get_expectations
      x.get_surprise(@nq1[0].pitch.val).should be < x.get_surprise(@nq1[1].pitch.val)
    end
    it "returns a random variable that only chooses states observed" do
      ppcs = PitchAndPitchClassSetCritic.new(order=1)
      ppcs.listen(@nq1.first)
      ppcs.reset
      x = ppcs.get_expectations
      Music::Pitch.new(*x.choose_outcome).val.should == @nq1.first.pitch.val
    end
  end

  context ".current_pitch_class_set" do
    it "should return a PitchClassSet" do
      ppcs = PitchAndPitchClassSetCritic.new(order=1)
      ppcs.current_pitch_class_set.should be_an_instance_of Music::PitchClassSet
    end
    it "should contain the last 'order' pitch classes listened to (if they're all unique)" do
      ppcs = PitchAndPitchClassSetCritic.new(order=2)
      ppcs.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(2)))
      ppcs.listen(Music::Note.new(Music::Pitch.new(1), Music::Duration.new(2)))
      ppcs.listen(Music::Note.new(Music::Pitch.new(2), Music::Duration.new(2)))
      ppcs.listen(Music::Note.new(Music::Pitch.new(3), Music::Duration.new(2)))

      expected_pcs = Music::PitchClassSet.new
      expected_pcs.add(Music::PitchClass.from_pitch(Music::Pitch.new(2)))
      expected_pcs.add(Music::PitchClass.from_pitch(Music::Pitch.new(3)))

      ppcs.current_pitch_class_set.vals.should == expected_pcs.vals
    end
    it "should contain the last 'order' unique pitch classes listened to" do
      ppcs = PitchAndPitchClassSetCritic.new(order=2)
      ppcs.listen(Music::Note.new(Music::Pitch.new(0), Music::Duration.new(2)))
      ppcs.listen(Music::Note.new(Music::Pitch.new(1), Music::Duration.new(2)))
      ppcs.listen(Music::Note.new(Music::Pitch.new(2), Music::Duration.new(2)))
      ppcs.listen(Music::Note.new(Music::Pitch.new(2), Music::Duration.new(2)))

      expected_pcs = Music::PitchClassSet.new
      expected_pcs.add(Music::PitchClass.from_pitch(Music::Pitch.new(1)))
      expected_pcs.add(Music::PitchClass.from_pitch(Music::Pitch.new(2)))

      ppcs.current_pitch_class_set.vals.should == expected_pcs.vals
    end
  end

end
