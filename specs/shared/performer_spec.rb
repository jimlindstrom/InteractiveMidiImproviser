#!/usr/bin/env ruby 

require 'spec_helper'

# assumes the following have been defined:
#    @performer
#    @event_queue
shared_examples_for "a performer" do
  context ".perform" do
    it "takes an event queue" do
      @performer.perform @event_queue
    end
  end
end
