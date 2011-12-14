# beat_position_spec.rb

require 'spec_helper'

describe Music::DurationAndBeatPosition do

  before(:each) do
    @bp = Music::BeatPosition.new
    @bp.measure = nil
    @bp.beat    = 2
    @bp.subbeat = 3
    @bp.beats_per_measure = 4
    @bp.subbeats_per_beat = 4

    @d = Music::Duration.new(3)
  end

  context "num_values" do
    it "should return 202752" do
      Music::DurationAndBeatPosition.num_values.should == Music::Duration.num_values*Music::BeatPosition.num_values
    end
  end

  context "to_symbol" do
    it "should return a DurationAndBeatPositionSymbol" do
      dbp = Music::DurationAndBeatPosition.new(@d, @bp)
      dbp.to_symbol.should be_an_instance_of Music::DurationAndBeatPositionSymbol
    end
    it "should return a DurationAndBeatPositionSymbol whose duration corresponds to the DurationAndBeatPosition's duration" do
      dbp = Music::DurationAndBeatPosition.new(@d, @bp)
      dbp.to_symbol.to_object.duration.val.should == dbp.duration.val
    end
    it "should return a DurationAndBeatPositionSymbol whose beat position corresponds to the DurationAndBeatPosition's beat position" do
      dbp = Music::DurationAndBeatPosition.new(@d, @bp)
      dbp.to_symbol.to_object.beat_position.to_hash.should == dbp.beat_position.to_hash
    end
  end

  context "beat_position" do
    it "should return whatever you set it to" do
      dbp = Music::DurationAndBeatPosition.new(@d, @bp)
      dbp.beat_position.to_hash.should == @bp.to_hash
    end
  end

  context "duration" do
    it "should return whatever you set it to" do
      dbp = Music::DurationAndBeatPosition.new(@d, @bp)
      dbp.duration.val.should == @d.val
    end
  end

end
