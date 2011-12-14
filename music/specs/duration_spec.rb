#!/usr/bin/env ruby

require 'spec_helper'

describe Music::Duration do
  before do
  end

  context "new" do
    it "should take an integer from 0 to 127" do
      Music::Duration.new(0).should be_an_instance_of Music::Duration
    end
    it "should take an integer from 0 to 127" do
      Music::Duration.new(127).should be_an_instance_of Music::Duration
    end
    it "raise an error on integers < 0" do
      expect { Music::Duration.new(-1) }.to raise_error(ArgumentError)
    end
    it "raise an error on integers > 127" do
      expect { Music::Duration.new(128) }.to raise_error(ArgumentError)
    end
  end

  context "to_symbol" do
    it "should return a DurationSymbol" do
      p = Music::Duration.new(0)
      p.to_symbol.should be_an_instance_of Music::DurationSymbol
    end
    it "should return a DurationSymbol whose value corresponds to the Duration's value" do
      p = Music::Duration.new(10)
      p.to_symbol.val.should equal 10
    end
  end

  context "val" do
    it "should get the value of the duration" do
      p = Music::Duration.new(10)
      p.val.should equal 10
    end
  end

  context "set_val" do
    it "should set the value of the duration" do
      p = Music::Duration.new(10)
      p.set_val(5)
      p.val.should equal 5
    end
  end

  context "similarity_to" do
    it "should return 0.0 when compared to nil" do
      d1 = Music::Duration.new(1)
      d1.similarity_to(nil).should be_within(0.01).of(0.0)
    end
    it "should return 0.0 when compared to a radically different duration" do
      d1 = Music::Duration.new(1)
      d2 = Music::Duration.new(10)
      d1.similarity_to(d2).should be_within(0.01).of(0.0)
    end
    it "should return 1.0 when compared to itself" do
      d1 = Music::Duration.new(1)
      d2 = Music::Duration.new(1)
      d1.similarity_to(d2).should be_within(0.01).of(1.0)
    end
  end

end
