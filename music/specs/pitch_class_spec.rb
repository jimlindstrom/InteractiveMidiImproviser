# beat_position_spec.rb

require 'spec_helper'

describe Music::PitchClass do

  before(:each) do
  end

  context "initialize" do
    it "should take a value in 0..11 and return a new PitchClass" do
      Music::PitchClass.new(0).should be_an_instance_of Music::PitchClass
    end
    it "should raise an error for pitch classes < 0" do
      expect { Music::PitchClass.new(-1) }.to raise_error(ArgumentError)
    end
    it "should raise an error for pitch classes > 11" do
      expect { Music::PitchClass.new(12) }.to raise_error(ArgumentError)
    end
  end

  context "from_pitch" do
    it "should take a pitch and return a new PitchClass" do
      pc = Music::PitchClass.from_pitch(Music::Pitch.new(0))
      pc.should be_an_instance_of Music::PitchClass
    end
    it "should map A0 to pitch class 0" do
      pc = Music::PitchClass.from_pitch(Music::Pitch.new(21))
      pc.val.should == 0
    end
    it "should map G#0 to pitch class 11" do
      pc = Music::PitchClass.from_pitch(Music::Pitch.new(21+11))
      pc.val.should == 11
    end
    it "should map A1 to pitch class 0" do
      pc = Music::PitchClass.from_pitch(Music::Pitch.new(21+12))
      pc.val.should == 0
    end
  end

  context "val" do
    it "should return whatever you initialized it to" do
      pc = Music::PitchClass.new(5)
      pc.val.should == 5
    end
  end

end
