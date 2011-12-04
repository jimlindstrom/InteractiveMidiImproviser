#!/usr/bin/env ruby 

require 'spec_helper'

describe DurationAndBeatPositionSymbol do
  before do
  end

  context "new" do
    it "should take an integer from 0 to 202751" do
      DurationAndBeatPositionSymbol.new(0).should be_an_instance_of DurationAndBeatPositionSymbol
    end
    it "should take an integer from 0 to 202751" do
      DurationAndBeatPositionSymbol.new(202751).should be_an_instance_of DurationAndBeatPositionSymbol
    end
    it "raise an error on integers < 0" do
      expect { DurationAndBeatPositionSymbol.new(-1) }.to raise_error(ArgumentError)
    end
    it "raise an error on integers > 202751" do
      expect { DurationAndBeatPositionSymbol.new(202752) }.to raise_error(ArgumentError)
    end
  end

  context "to_object" do
    it "should return a DurationAndBeatPosition" do
      dbps = DurationAndBeatPositionSymbol.new(0)
      dbps.to_object.should be_an_instance_of DurationAndBeatPosition
    end
    it "should return a DurationAndBeatPosition whose value corresponds to the DurationAndBeatPositionSymbol's value" do
      dbps = DurationAndBeatPositionSymbol.new(110232)
      dbps.to_object.to_symbol.val.should == dbps.val
    end
  end

  context "val" do
    it "should get the value of the beat_position" do
      dbps = DurationAndBeatPositionSymbol.new(10)
      dbps.val.should == 10
    end
  end

  context "set_val" do
    it "should set the value of the beat_position" do
      dbps = DurationAndBeatPositionSymbol.new(10)
      dbps.set_val(5)
      dbps.val.should == 5
    end
  end
end
