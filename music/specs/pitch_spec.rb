#!/usr/bin/env ruby 

require 'spec_helper'

describe Music::Pitch do
  context "new" do
    it "should take an integer from 0 to 127" do
      Music::Pitch.new(0).should be_an_instance_of Music::Pitch
    end
    it "should take an integer from 0 to 127" do
      Music::Pitch.new(127).should be_an_instance_of Music::Pitch
    end
    it "raise an error on integers < 0" do
      expect { Music::Pitch.new(-1) }.to raise_error(ArgumentError)
    end
    it "raise an error on integers > 127" do
      expect { Music::Pitch.new(128) }.to raise_error(ArgumentError)
    end
  end

  context "num_values" do
    it "should return 128" do
      Music::Pitch.num_values.should == 128
    end
  end

  context "val" do
    it "should get the value of the pitch" do
      p = Music::Pitch.new(10)
      p.val.should equal 10
    end
  end

  context "set_val" do
    it "should set the value of the pitch" do
      p = Music::Pitch.new(10)
      p.set_val(5)
      p.val.should equal 5
    end
  end

  context "similarity_to" do
    before(:each) do
      @p1 = Music::Pitch.new(0)
    end
    context "when compared to nil" do
      it "should return 0.0" do
        @p1.similarity_to(nil).should be_within(0.01).of(0.0)
      end
    end
    context "when compared to a radically differen pitch" do
      it "should return 0.0" do
        p2 = Music::Pitch.new(100)
        @p1.similarity_to(p2).should be_within(0.01).of(0.0)
      end
    end
    context "when compared to itself" do
      it "should return 1.0" do
        @p1.similarity_to(@p1).should be_within(0.01).of(1.0)
      end
    end
  end

end
