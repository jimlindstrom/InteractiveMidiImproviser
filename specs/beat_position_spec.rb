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

  context "num_beats" do
    it "should return whatever you set it to" do
      b=BeatPosition.new
      b.num_beats = 10
      b.num_beats.should == 10
    end
  end

  context "subdiv" do
    it "should return whatever you set it to" do
      b=BeatPosition.new
      b.subdiv = 10
      b.subdiv.should == 10
    end
  end

  context "num_subdivs" do
    it "should return whatever you set it to" do
      b=BeatPosition.new
      b.num_subdivs = 10
      b.num_subdivs.should == 10
    end
  end

  context "to_hash" do
    it "should reutrn a hash of the measure, beat, and subdiv" do
      b=BeatPosition.new
      b.measure = 12
      b.beat    = 2
      b.subdiv  = 3
      b.to_hash.should == {:measure=>12, :beat=>2, :subdiv=>3}
    end
  end

end
