#!/usr/bin/env ruby

require 'spec_helper'

describe Interval do
  before do
  end

  context "new" do
    it "should take an integer from -127 to 127" do
      Interval.new(-127).should be_an_instance_of Interval
    end
    it "should take an integer from -127 to 127" do
      Interval.new(127).should be_an_instance_of Interval
    end
    it "raise an error on integers < -127" do
      expect { Interval.new(-128) }.to raise_error(ArgumentError)
    end
    it "raise an error on integers > 127" do
      expect { Interval.new(128) }.to raise_error(ArgumentError)
    end
  end

  context "num_values" do
    it "should return 255" do
      Interval.num_values.should be 255
    end
  end

  context "calculate" do
    it "should return a new Interval" do
      p1 = Pitch.new(0)
      p2 = Pitch.new(10)
      Interval.calculate(p1, p2).should be_an_instance_of Interval
    end
    it "should calculate the difference between the first pitch and the second pitch" do
      p1 = Pitch.new(0)
      p2 = Pitch.new(10)
      Interval.calculate(p1, p2).val.should equal 10
    end
  end

  context "to_symbol" do
    it "should return a IntervalSymbol" do
      p = Interval.new(0)
      p.to_symbol.should be_an_instance_of IntervalSymbol
    end
    it "should return a IntervalSymbol whose value corresponds to the Interval's value" do
      p = Interval.new(10)
      p.to_symbol.val.should equal 137
    end
    it "should perform the inverse of IntervalSymbol.to_interval" do
      p = Interval.new(127)
      p.to_symbol.to_interval.val.should be 127
    end
    it "should perform the inverse of IntervalSymbol.to_interval" do
      p = Interval.new(-127)
      p.to_symbol.to_interval.val.should be -127
    end
  end

  context "val" do
    it "should get the value of the interval" do
      p = Interval.new(10)
      p.val.should equal 10
    end
  end

  context "set_val" do
    it "should set the value of the interval" do
      p = Interval.new(10)
      p.set_val(5)
      p.val.should equal 5
    end
  end
end
