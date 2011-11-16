#!/usr/bin/env ruby 

require 'spec_helper'

# assumes the following have been defined:
#    @sensor 
#    @expected_num_responses 
shared_examples_for "a sensor" do
  context ".get_stimulus" do
    it "return a Midi::EventQueue" do
      @sensor.get_stimulus.should be_an_instance_of Midi::EventQueue
    end
    it "return nil if there are no more stimuli" do
      stimuli          = []
      expected_stimuli = []
      @expected_num_responses.times do
        stimuli.push @sensor.get_stimulus.class
        expected_stimuli.push Midi::EventQueue
      end

      stimuli.push @sensor.get_stimulus.class
      expected_stimuli.push NilClass

      stimuli.should be == expected_stimuli
    end
  end
end
