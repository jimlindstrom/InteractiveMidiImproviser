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
      use_real_midi=false
      i.run(use_real_midi)
      pending("still need to test side effects")
    end
  end

  context ".get_single_improvisation" do
    before(:all) do
      @i = InteractiveImprovisor.new
      @i.train
    end
    it "should generate metrically-intelligable improvisations >80% of the time" do
      correct_detections = 0
      100.times do
        nq = @i.get_single_improvisation
        if nq.detect_meter
          correct_detections += 1
        end
      end
      correct_detections.should be > 80
    end
  end
end
