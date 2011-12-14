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

  context "to_object" do
    it "should return a BeatPosition" do
      b = BeatPositionSymbol.new(0)
      b.to_object.should be_an_instance_of BeatPosition
    end
    it "should return a BeatPosition whose value corresponds to the BeatPositionSymbol's value" do
      b = BeatPositionSymbol.new(1102)
      b.to_object.to_symbol.val.should == b.val
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
