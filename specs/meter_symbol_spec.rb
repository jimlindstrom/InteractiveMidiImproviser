#!/usr/bin/env ruby 

require 'spec_helper'

describe MeterSymbol do
  before do
  end

  context "new" do
    it "should take an integer from 0 to 131" do
      MeterSymbol.new(0).should be_an_instance_of MeterSymbol
    end
    it "should take an integer from 0 to 131" do
      MeterSymbol.new(131).should be_an_instance_of MeterSymbol
    end
    it "raise an error on integers < 0" do
      expect { MeterSymbol.new(-1) }.to raise_error(ArgumentError)
    end
    it "raise an error on integers > 131" do
      expect { MeterSymbol.new(132) }.to raise_error(ArgumentError)
    end
  end

  context "to_meter" do
    it "should return a Meter" do
      m = MeterSymbol.new(0)
      m.to_meter.should be_an_instance_of Meter
    end
    it "should return a Meter whose value corresponds to the MeterSymbol's value" do
      m = MeterSymbol.new(0)
      m.to_meter.beats_per_measure.should equal 2
      m.to_meter.beat_unit.should equal 2
      m.to_meter.subdivs_per_beat.should equal 1
    end
  end

  context "val" do
    it "should get the value of the meter" do
      m = MeterSymbol.new(10)
      m.val.should equal 10
    end
  end

  context "set_val" do
    it "should set the value of the meter" do
      m = MeterSymbol.new(10)
      m.set_val(5)
      m.val.should equal 5
    end
  end
end
