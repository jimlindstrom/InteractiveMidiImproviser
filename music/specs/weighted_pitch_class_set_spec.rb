# beat_position_spec.rb

require 'spec_helper'

describe Music::WeightedPitchClassSet do

  before(:each) do
  end

  context "initialize" do
    it "should return a new WeightedPitchClass" do
      Music::WeightedPitchClassSet.new().should be_an_instance_of Music::WeightedPitchClassSet
    end
  end

  context "add" do
    it "should add the new weighting to the pitch class' existing weighting" do
      wpcs = Music::WeightedPitchClassSet.new()
      wpcs.add(pitch_class=Music::PitchClass.new(0),weight=2.5)
      wpcs.weight(pitch_class).should be_within(0.01).of(2.5)
    end
  end

  context "weight" do
    it "should return 0.0 if no weight has been added" do
      wpcs = Music::WeightedPitchClassSet.new()
      wpcs.weight(pitch_class=Music::PitchClass.new(0)).should == 0.0
    end
    it "should contain the sum of all weights added" do
      wpcs = Music::WeightedPitchClassSet.new()
      wpcs.add(Music::PitchClass.new(0), weight=1.0)
      wpcs.add(Music::PitchClass.new(4), weight=1.1)
      wpcs.add(Music::PitchClass.new(4), weight=1.1)
      wpcs.add(Music::PitchClass.new(1), weight=1.2)
      wpcs.weight(Music::PitchClass.new(4)).should be_within(0.01).of(2.2)
    end
  end

  context "pitch_classes_above_threshold" do
    before(:all) do
      @wpcs = Music::WeightedPitchClassSet.new()
      @wpcs.add(Music::PitchClass.new(5), weight=8.0)
      @wpcs.add(Music::PitchClass.new(0), weight=1.0)
      @wpcs.add(Music::PitchClass.new(4), weight=1.1)
      @wpcs.add(Music::PitchClass.new(4), weight=1.1)
      @wpcs.add(Music::PitchClass.new(1), weight=1.2)
    end
    it "should return a PitchClassSet" do
      @wpcs.pitch_classes_above_threshold(1.15).should be_an_instance_of Music::PitchClassSet
    end
    it "should return pitch classes that have a weight above the threshold" do
      pcs = @wpcs.pitch_classes_above_threshold(1.15)
      pcs.vals.sort.should == [1, 4, 5]
    end
  end

  context "top_n_pitch_classes" do
    before(:all) do
      @wpcs = Music::WeightedPitchClassSet.new()
      @wpcs.add(Music::PitchClass.new(5), weight=8.0)
      @wpcs.add(Music::PitchClass.new(0), weight=1.0)
      @wpcs.add(Music::PitchClass.new(4), weight=1.1)
      @wpcs.add(Music::PitchClass.new(4), weight=1.1)
      @wpcs.add(Music::PitchClass.new(1), weight=1.2)
    end
    it "should return a PitchClassSet" do
      @wpcs.top_n_pitch_classes(3).should be_an_instance_of Music::PitchClassSet
    end
    it "should return pitch classes with in the top N by weight" do
      pcs = @wpcs.top_n_pitch_classes(3)
      pcs.vals.sort.should == [1, 4, 5]
    end
  end

end
