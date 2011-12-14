#!/usr/bin/env ruby 

require 'spec_helper'

describe PitchSymbol do
  before do
  end

  context "new" do
    it "should take an integer from 0 to 127" do
      PitchSymbol.new(0).should be_an_instance_of PitchSymbol
    end
    it "should take an integer from 0 to 127" do
      PitchSymbol.new(127).should be_an_instance_of PitchSymbol
    end
    it "raise an error on integers < 0" do
      expect { PitchSymbol.new(-1) }.to raise_error(ArgumentError)
    end
    it "raise an error on integers > 127" do
      expect { PitchSymbol.new(128) }.to raise_error(ArgumentError)
    end
  end

  context "to_object" do
    it "should return a Pitch" do
      p = PitchSymbol.new(0)
      p.to_object.should be_an_instance_of Pitch
    end
    it "should return a Pitch whose value corresponds to the PitchSymbol's value" do
      p = PitchSymbol.new(10)
      p.to_object.val.should equal 10
    end
  end

  context "val" do
    it "should get the value of the pitch" do
      p = PitchSymbol.new(10)
      p.val.should equal 10
    end
  end

  context "set_val" do
    it "should set the value of the pitch" do
      p = PitchSymbol.new(10)
      p.set_val(5)
      p.val.should equal 5
    end
  end
end
