#!/usr/bin/env ruby 

require 'spec_helper'

describe BeatPositionSymbol do
  before do
  end

  context "new" do
    it "should take an integer from 0 to 1583" do
      BeatPositionSymbol.new(0).should be_an_instance_of BeatPositionSymbol
    end
    it "should take an integer from 0 to 1583" do
      BeatPositionSymbol.new(1583).should be_an_instance_of BeatPositionSymbol
    end
    it "raise an error on integers < 0" do
      expect { BeatPositionSymbol.new(-1) }.to raise_error(ArgumentError)
    end
    it "raise an error on integers > 1583" do
      expect { BeatPositionSymbol.new(1584) }.to raise_error(ArgumentError)
    end
  end

  context "to_beat_position" do
    it "should return a BeatPosition" do
      b = BeatPositionSymbol.new(0)
      b.to_beat_position.should be_an_instance_of BeatPosition
    end
    it "should return a BeatPosition whose value corresponds to the BeatPositionSymbol's value" do
      b = BeatPositionSymbol.new(1102)
      x = {}
      x[:beat] = b.to_beat_position.beat
      x[:subbeat] = b.to_beat_position.subbeat
      x[:beats_per_measure] = b.to_beat_position.beats_per_measure
      x[:subbeats_per_beat] = b.to_beat_position.subbeats_per_beat
      x.should == {:beat=>8, :subbeat=>2, :beats_per_measure=>6, :subbeats_per_beat=>2}
    end
  end

  context "val" do
    it "should get the value of the beat_position" do
      b = BeatPositionSymbol.new(10)
      b.val.should == 10
    end
  end

  context "set_val" do
    it "should set the value of the beat_position" do
      b = BeatPositionSymbol.new(10)
      b.set_val(5)
      b.val.should == 5
    end
  end
end
