# beat_position_spec.rb

require 'spec_helper'

describe DurationAndBeatPosition do

  before(:each) do
    @bp = BeatPosition.new
    @bp.measure = nil
    @bp.beat    = 2
    @bp.subbeat = 3
    @bp.beats_per_measure = 4
    @bp.subbeats_per_beat = 4

    @d = Duration.new(3)
  end

  context "num_values" do
    it "should return 202752" do
      DurationAndBeatPosition.num_values.should == Duration.num_values*BeatPosition.num_values
    end
  end

  context "to_symbol" do
    it "should return a DurationAndBeatPositionSymbol" do
      dbp = DurationAndBeatPosition.new(@d, @bp)
      dbp.to_symbol.should be_an_instance_of DurationAndBeatPositionSymbol
    end
    it "should return a DurationAndBeatPositionSymbol whose duration corresponds to the DurationAndBeatPosition's duration" do
      dbp = DurationAndBeatPosition.new(@d, @bp)
      dbp.to_symbol.to_object.duration.val.should == dbp.duration.val
    end
    it "should return a DurationAndBeatPositionSymbol whose beat position corresponds to the DurationAndBeatPosition's beat position" do
      dbp = DurationAndBeatPosition.new(@d, @bp)
      dbp.to_symbol.to_object.beat_position.to_hash.should == dbp.beat_position.to_hash
    end
  end

  context "beat_position" do
    it "should return whatever you set it to" do
      dbp = DurationAndBeatPosition.new(@d, @bp)
      dbp.beat_position.to_hash.should == @bp.to_hash
    end
  end

  context "duration" do
    it "should return whatever you set it to" do
      dbp = DurationAndBeatPosition.new(@d, @bp)
      dbp.duration.val.should == @d.val
    end
  end

end
