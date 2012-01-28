#!/usr/bin/env ruby 

require 'spec_helper'

describe Music::Rest do
  before do
  end

  context "new" do
    it "should take a duration" do
      Music::Rest.new(Music::Duration.new(0)).should be_an_instance_of Music::Rest
    end
  end

  context "duration" do
    it "should return the duration it was created with" do
      duration_val = 10
      r = Music::Rest.new(Music::Duration.new(duration_val))
      r.duration.val.should be duration_val
    end
  end

  context "analysis" do
    it "should return a hash that can be extended with whatever values critics want" do
      r = Music::Rest.new(Music::Duration.new(3))
      r.analysis.should be_an_instance_of Hash
    end
  end

end
