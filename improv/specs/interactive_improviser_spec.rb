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
      num_training_vectors = 20
      i.train(num_training_vectors)
      pending("still need to test side effects")
    end
  end

  context ".run" do
    it "should listen for stimuli and play responses" do
      i = InteractiveImprovisor.new
      num_training_vectors = 20
      i.train(num_training_vectors)
      use_real_midi=false
      i.run(use_real_midi)
      pending("still need to test side effects")
    end
  end

  context ".get_single_improvisation" do
    before(:all) do
      @i = InteractiveImprovisor.new
      num_training_vectors = 20
      @i.train(num_training_vectors)
    end
    it "should generate metrically-intelligable improvisations >70% of the time" do
      correct_detections = 0
      10.times do
        nq = @i.get_single_improvisation
        if nq.detect_meter
          # an even better test would be to see if the detected meter is the same as the planned meter
          correct_detections += 1
        end
      end
      correct_detections.should be > 7
    end
  end
end
