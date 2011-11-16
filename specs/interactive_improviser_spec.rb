#!/usr/bin/env ruby 

require 'spec_helper'

describe InteractiveImprovisor do
  before do
  end

  context ".new" do
    it "should create a new InteractiveImprovisor" do
      i = InteractiveImprovisor.new
      i.should be_an_instance_of InteractiveImprovisor
    end
  end

  context ".train" do
    it "should listen for stimuli and play responses" do
      i = InteractiveImprovisor.new
      i.train
      pending("still need to test side effects")
    end
  end

  context ".run" do
    it "should listen for stimuli and play responses" do
      i = InteractiveImprovisor.new
      i.train
      i.run
      pending("still need to test side effects")
    end
  end
end
