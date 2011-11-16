#!/usr/bin/env ruby

require 'spec_helper'

describe Duration do
  before do
  end

  context "new" do
    it "should take an integer from 0 to 127" do
      Duration.new(0).should be_an_instance_of Duration
    end
    it "should take an integer from 0 to 127" do
      Duration.new(127).should be_an_instance_of Duration
    end
    it "raise an error on integers < 0" do
      expect { Duration.new(-1) }.to raise_error(ArgumentError)
    end
    it "raise an error on integers > 127" do
      expect { Duration.new(128) }.to raise_error(ArgumentError)
    end
  end

  context "to_symbol" do
    it "should return a DurationSymbol" do
      p = Duration.new(0)
      p.to_symbol.should be_an_instance_of DurationSymbol
    end
    it "should return a DurationSymbol whose value corresponds to the Duration's value" do
      p = Duration.new(10)
      p.to_symbol.val.should equal 10
    end
  end

  context "val" do
    it "should get the value of the duration" do
      p = Duration.new(10)
      p.val.should equal 10
    end
  end

  context "set_val" do
    it "should set the value of the duration" do
      p = Duration.new(10)
      p.set_val(5)
      p.val.should equal 5
    end
  end
end
