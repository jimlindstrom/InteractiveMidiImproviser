#!/usr/bin/env ruby 

require 'spec_helper'

describe Pitch do
  before do
  end

  context "new" do
    it "should take an integer from 0 to 127" do
      Pitch.new(0).should be_an_instance_of Pitch
    end
    it "should take an integer from 0 to 127" do
      Pitch.new(127).should be_an_instance_of Pitch
    end
    it "raise an error on integers < 0" do
      expect { Pitch.new(-1) }.to raise_error(ArgumentError)
    end
    it "raise an error on integers > 127" do
      expect { Pitch.new(128) }.to raise_error(ArgumentError)
    end
  end

  context "num_values" do
    it "should return 128" do
      Pitch.num_values.should be 128
    end
  end

  context "to_symbol" do
    it "should return a PitchSymbol" do
      p = Pitch.new(0)
      p.to_symbol.should be_an_instance_of PitchSymbol
    end
    it "should return a PitchSymbol whose value corresponds to the Pitch's value" do
      p = Pitch.new(10)
      p.to_symbol.val.should equal 10
    end
  end

  context "val" do
    it "should get the value of the pitch" do
      p = Pitch.new(10)
      p.val.should equal 10
    end
  end

  context "set_val" do
    it "should set the value of the pitch" do
      p = Pitch.new(10)
      p.set_val(5)
      p.val.should equal 5
    end
  end
end