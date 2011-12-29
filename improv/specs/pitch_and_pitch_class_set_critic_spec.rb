#!/usr/bin/env ruby 

require 'spec_helper'

describe PitchAndPitchClassSetCritic do
  before(:each) do
    @vector = $meter_vectors["Bring back my bonnie to me"]
    @nq1 = @vector[:note_queue]
    @nq1.tag_with_notes_left

    @vector = $meter_vectors["Battle hymn of the republic"]
    @nq2 = @vector[:note_queue]
    @nq2.tag_with_notes_left
  end

  context ".new" do
    it "should return a PitchAndPitchClassSetCritic" do
      PitchAndPitchClassSetCritic.new(order=1, lookahead=1).should be_an_instance_of PitchAndPitchClassSetCritic
    end
  end

  context ".reset" do
    it "should reset to the state in which no notes have been heard yet" do
      ppcs = PitchAndPitchClassSetCritic.new(order=1, lookahead=1)
      ppcs.listen(@nq1.first)
      ppcs.reset
      x = ppcs.get_expectations
      Music::Pitch.new(x.choose_outcome).val.should == @nq1.first.pitch.val
    end
    it "should reset the current pitch class set" do
      ppcs = PitchAndPitchClassSetCritic.new(order=2, lookahead=1)
      ppcs.listen @nq1[0]
      ppcs.listen @nq1[1]
      ppcs.listen @nq1[2]
      ppcs.listen @nq1[3]
      ppcs.reset
      ppcs.current_pitch_class_set.vals.should == []
    end

  end

  context ".save" do
    it "should save a file, named <folder>/pitch_and_pitch_class_set_critic_<order>_<lookahead>.yml" do
      ppcs = PitchAndPitchClassSetCritic.new(order=1, lookahead=1)
      ppcs.listen(@nq1.first)
      ppcs.listen(@nq2.first)
      filename = "data/test/pitch_and_pitch_class_set_critic_#{order}_#{lookahead}.yml"
      File.delete filename if FileTest.exists? filename
      ppcs.save "data/test"
      FileTest.exists?(filename).should == true
    end
  end

  context ".load" do
    it "should load a file, named <folder>/pitch_and_pitch_class_set_critic_<order>_<lookahead>.yml, and act just like the saved critic" do
      ppcs = PitchAndPitchClassSetCritic.new(order=1, lookahead=1)
      ppcs.listen(@nq1[0])
      ppcs.listen(@nq1[1])
      ppcs.listen(@nq1[2])
      ppcs.reset
      ppcs.listen(@nq1[0])
      ppcs.listen(@nq1[1])
      ppcs.save "data/test"
      ppcs2 = PitchAndPitchClassSetCritic.new(order=1, lookahead=1)
      ppcs2.load "data/test"
      x = ppcs.get_expectations
      x2 = ppcs2.get_expectations
      x.choose_outcome.should == x2.choose_outcome
    end
  end

  context ".cumulative_information_content" do
    it "should return zero initially" do
      ppcs = PitchAndPitchClassSetCritic.new(order=1, lookahead=1)
      ppcs.cumulative_information_content.should be_within(0.0001).of(0.0)
    end
    it "should return the sum of all listening information_content" do
      ppcs = PitchAndPitchClassSetCritic.new(order=1, lookahead=1)
      cum_information_content = 0.0
      cum_information_content += ppcs.listen(@nq1[0])
      cum_information_content += ppcs.listen(@nq1[1])
      cum_information_content += ppcs.listen(@nq1[2])
      cum_information_content += ppcs.listen(@nq1[3])
      ppcs.cumulative_information_content.should be_within(0.0001).of(cum_information_content)
    end
    it "should return zero after calling reset_cumulative_information_content" do
      ppcs = PitchAndPitchClassSetCritic.new(order=1, lookahead=1)
      ppcs.listen(@nq1[0])
      ppcs.reset_cumulative_information_content
      ppcs.cumulative_information_content.should be_within(0.0001).of(0.0)
    end
  end

  context ".listen" do
    it "should raise an error if the note isn't tagged with the number of following notes" do
      ppcs = PitchAndPitchClassSetCritic.new(order=1, lookahead=1)
      note = Music::Note.new(Music::Pitch.new(0), Music::Duration.new(1))
      #note.analysis[:notes_left] = 1
      expect{ ppcs.listen(note) }.to raise_error(ArgumentError)
    end
    it "should return the information_content associated with the given note" do
      ppcs = PitchAndPitchClassSetCritic.new(order=1, lookahead=1)
      note = Music::Note.new(Music::Pitch.new(0), Music::Duration.new(1))
      note.analysis[:notes_left] = 1
      information_content = ppcs.listen(note)
	  information_content.should == Math::RandomVariable.max_information_content
    end
  end

  context ".get_expectations" do
    it "returns a random variable" do
      ppcs = PitchAndPitchClassSetCritic.new(order=1, lookahead=1)
      ppcs.get_expectations.should be_an_instance_of Math::RandomVariable
    end
    it "returns a random variable that is less information_contentd about states observed more often" do
      ppcs = PitchAndPitchClassSetCritic.new(order=1, lookahead=1)
      ppcs.listen(@nq1[0])
      ppcs.reset
      ppcs.listen(@nq1[0])
      ppcs.reset
      ppcs.listen(@nq1[1])
      ppcs.reset
      x = ppcs.get_expectations
      x.information_content(@nq1[0].pitch.val).should be < x.information_content(@nq1[1].pitch.val)
    end
    it "returns a random variable that only chooses states observed" do
      ppcs = PitchAndPitchClassSetCritic.new(order=1, lookahead=1)
      ppcs.listen(@nq1.first)
      ppcs.reset
      x = ppcs.get_expectations
      Music::Pitch.new(*x.choose_outcome).val.should == @nq1.first.pitch.val
    end
  end

  context ".current_pitch_class_set" do
    it "should return a PitchClassSet" do
      ppcs = PitchAndPitchClassSetCritic.new(order=1, lookahead=1)
      ppcs.current_pitch_class_set.should be_an_instance_of Music::PitchClassSet
    end
    it "should contain no more pitch classes than the 'order'" do
      ppcs = PitchAndPitchClassSetCritic.new(order=2, lookahead=1)
      0.upto(10) { |i| ppcs.listen @nq1[i] }
      ppcs.current_pitch_class_set.vals.length.should be <= order
    end
    it "should contain some subset of pitch classes listened to" do
      ppcs = PitchAndPitchClassSetCritic.new(order=2, lookahead=1)
      expected_pcs = Music::PitchClassSet.new
      0.upto(10) do |i| 
        cur_note = @nq1[i]
        ppcs.listen cur_note
        expected_pcs.add Music::PitchClass.from_pitch(cur_note.pitch)
      end

      (ppcs.current_pitch_class_set.vals - expected_pcs.vals).should == []
    end
  end

end
