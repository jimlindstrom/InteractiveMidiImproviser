# beat_position_spec.rb

require 'spec_helper'

describe Music::BeatPosition do

  before(:each) do
  end

  context "num_values" do
    it "should return 360" do
      Music::BeatPosition.num_values.should == 360
    end
  end

  context "+" do
    it "should take a BeatPosition and a Duration and return a new BeatPosition" do
      m = Music::Meter.random
      b = m.initial_beat_position
      d = Music::Duration.new(9)
      (b + d).should be_an_instance_of Music::BeatPosition
    end
    it "should add the Duration to the BeatPosition" do
      m = Music::Meter.new(4, 4, 2) # 4/4 in eighth notes
      b = m.initial_beat_position
      d = Music::Duration.new(2+1) # 3 eighth notes
      x = b + d
      x.to_hash.should == {:measure=>0, :beat=>1, :subbeat=>1}
    end
    it "should add the Duration to the BeatPosition, wrapping measures as needed" do
      m = Music::Meter.new(4, 4, 2) # 4/4 in eighth notes
      b = m.initial_beat_position
      d = Music::Duration.new(8+4+1) # 3 eighth notes
      x = b + d
      x.to_hash.should == {:measure=>1, :beat=>2, :subbeat=>1}
    end
  end

  context "measure" do
    it "should return whatever you set it to" do
      b=Music::BeatPosition.new
      b.measure = 10
      b.measure.should == 10
    end
  end

  context "beat" do
    it "should return whatever you set it to" do
      b=Music::BeatPosition.new
      b.beat = 10
      b.beat.should == 10
    end
  end

  context "beats_per_measure" do
    it "should return whatever you set it to" do
      b=Music::BeatPosition.new
      b.beats_per_measure = 10
      b.beats_per_measure.should == 10
    end
  end

  context "subbeat" do
    it "should return whatever you set it to" do
      b=Music::BeatPosition.new
      b.subbeat = 10
      b.subbeat.should == 10
    end
  end

  context "subbeats_per_beat" do
    it "should return whatever you set it to" do
      b=Music::BeatPosition.new
      b.subbeats_per_beat = 10
      b.subbeats_per_beat.should == 10
    end
  end

  context "to_hash" do
    it "should reutrn a hash of the measure, beat, and subbeat" do
      b=Music::BeatPosition.new
      b.measure = 12
      b.beat    = 2
      b.subbeat = 3
      b.to_hash.should == {:measure=>12, :beat=>2, :subbeat=>3}
    end
  end

end
