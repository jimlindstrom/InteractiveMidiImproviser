#!/usr/bin/env ruby 

require 'spec_helper'

describe Listener do
  before do
    @vector = $meter_vectors["Bring back my bonnie to me"]
    @nq = @vector[:note_queue]
    @nq.detect_meter
    @nq.tag_with_notes_left
  end

  context ".add_critic" do
    it "should cause that critic to listen to (future) events" do
      l = Listener.new

      c = PitchCritic.new(1)
      l.add_critic(c)

      c.should_receive(:listen).exactly(60).times

      l.listen @nq
    end
  end

  context ".listen" do
    it "should reset all critics and then cause them to listen to a sequence of notes" do
      l = Listener.new

      c1 = PitchCritic.new(1)
      l.add_critic(c1)
      c1.should_receive(:reset).once
      c1.should_receive(:listen).exactly(60).times

      c2 = DurationCritic.new(1)
      l.add_critic(c2)
      c2.should_receive(:reset).once
      c2.should_receive(:listen).exactly(60).times

      l.listen @nq
    end
  end
end
