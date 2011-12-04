#!/usr/bin/env ruby

require 'spec_helper'

describe DurationSymbol do
  before do
  end

  context "new" do
    it "should take an integer from 0 to 127" do
      DurationSymbol.new(0).should be_an_instance_of DurationSymbol
    end
    it "should take an integer from 0 to 127" do
      DurationSymbol.new(127).should be_an_instance_of DurationSymbol
    end
    it "raise an error on integers < 0" do
      expect { DurationSymbol.new(-1) }.to raise_error(ArgumentError)
    end
    it "raise an error on integers > 127" do
      expect { DurationSymbol.new(128) }.to raise_error(ArgumentError)
    end
  end

  context "to_object" do
    it "should return a Duration" do
      p = DurationSymbol.new(0)
      p.to_object.should be_an_instance_of Duration
    end
    it "should return a Duration whose value corresponds to the DurationSymbol's value" do
      p = DurationSymbol.new(10)
      p.to_object.val.should equal 10
    end
  end

  context "val" do
    it "should get the value of the symbol" do
      p = DurationSymbol.new(10)
      p.val.should equal 10
    end
  end

  context "set_val" do
    it "should set the value of the symbol" do
      p = DurationSymbol.new(10)
      p.set_val(5)
      p.val.should equal 5
    end
  end
end
