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
