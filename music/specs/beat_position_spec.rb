# beat_position_spec.rb

require 'spec_helper'

describe BeatPosition do

  before(:each) do
  end

  context "num_values" do
    it "should return 1584" do
      BeatPosition.num_values.should == 1584
    end
  end

  context "+" do
    it "should take a BeatPosition and a Duration and return a new BeatPosition" do
      m = Meter.random
      b = m.initial_beat_position
      d = Duration.new(9)
      (b + d).should be_an_instance_of BeatPosition
    end
    it "should add the Duration to the BeatPosition" do
      m = Meter.new(4, 4, 2) # 4/4 in eighth notes
      b = m.initial_beat_position
      d = Duration.new(2+1) # 3 eighth notes
      x = b + d
      x.to_hash.should == {:measure=>0, :beat=>1, :subbeat=>1}
    end
    it "should add the Duration to the BeatPosition, wrapping measures as needed" do
      m = Meter.new(4, 4, 2) # 4/4 in eighth notes
      b = m.initial_beat_position
      d = Duration.new(8+4+1) # 3 eighth notes
      x = b + d
      x.to_hash.should == {:measure=>1, :beat=>2, :subbeat=>1}
    end
  end

  context "to_symbol" do
    it "should return a BeatPositionSymbol" do
      b = BeatPosition.new
      b.measure = 0
      b.beat    = 2
      b.subbeat = 3
      b.beats_per_measure = 4
      b.subbeats_per_beat = 1
      b.to_symbol.should be_an_instance_of BeatPositionSymbol
    end
    it "should return a BeatPositionSymbol whose value corresponds to the BeatPosition's value" do
      b = BeatPosition.new
      b.measure = 0
      b.beat    = 2
      b.subbeat = 3
      b.beats_per_measure = 4
      b.subbeats_per_beat = 1

      keys = [:beat, :beats_per_measure, :subbeat, :subbeats_per_beat]
      obj1 = b
      h1   = Hash[*keys.zip(keys.map{ |x| obj1.send(x.to_s) }).flatten]

      keys = [:beat, :beats_per_measure, :subbeat, :subbeats_per_beat]
      obj2 = b.to_symbol.to_object
      h2   = Hash[*keys.zip(keys.map{ |x| obj2.send(x.to_s) }).flatten]

      h1.should == h2
    end
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
