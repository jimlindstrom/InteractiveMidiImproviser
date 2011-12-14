#!/usr/bin/env ruby 

# Listener
# 	Listen(NoteQueue) # a completed stimulus
# 		Takes a NoteQueue
# 		Resets all critics
# 		For each Note in NoteQueue
# 			Cause each critics to listen
# 	AddCritic
# 		Adds the critic to the internal list of critics who will listen to each note

require 'spec_helper'

describe Listener do
  before do
  end

  context ".add_critic" do
    it "should cause that critic to listen to (future) events" do
      l = Listener.new

      c = PitchCritic.new(1)
      l.add_critic(c)

      c.should_receive(:listen)

      l.listen [Note.new(Pitch.new(0), Duration.new(1))]
    end
  end

  context ".listen" do
    it "should reset all critics and then cause them to listen to a sequence of notes" do
      notes = [Note.new(Pitch.new(0), Duration.new(1)), Note.new(Pitch.new(0), Duration.new(1)), Note.new(Pitch.new(0), Duration.new(1))]

      l = Listener.new

      c1 = PitchCritic.new(1)
      l.add_critic(c1)
      c1.should_receive(:reset).once
      c1.should_receive(:listen).exactly(3).times

      c2 = DurationCritic.new(1)
      l.add_critic(c2)
      c2.should_receive(:reset).once
      c2.should_receive(:listen).exactly(3).times

      l.listen notes
    end
  end
end
