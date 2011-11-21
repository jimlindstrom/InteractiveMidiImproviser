# beat_position_spec.rb

require 'spec_helper'

describe BeatPosition do

  before(:each) do
  end

  context "measure" do
    it "should return whatever you set it to" do
      b=BeatPosition.new
      b.measure = 10
      b.measure.should == 10
    end
  end

  context "beat" do
    it "should return whatever you set it to" do
      b=BeatPosition.new
      b.beat = 10
      b.beat.should == 10
    end
  end

  context "beats_per_measure" do
    it "should return whatever you set it to" do
      b=BeatPosition.new
      b.beats_per_measure = 10
      b.beats_per_measure.should == 10
    end
  end

  context "subbeat" do
    it "should return whatever you set it to" do
      b=BeatPosition.new
      b.subbeat = 10
      b.subbeat.should == 10
    end
  end

  context "subbeats_per_beat" do
    it "should return whatever you set it to" do
      b=BeatPosition.new
      b.subbeats_per_beat = 10
      b.subbeats_per_beat.should == 10
    end
  end

  context "to_hash" do
    it "should reutrn a hash of the measure, beat, and subbeat" do
      b=BeatPosition.new
      b.measure = 12
      b.beat    = 2
      b.subbeat = 3
      b.to_hash.should == {:measure=>12, :beat=>2, :subbeat=>3}
    end
  end

end
