#!/usr/bin/env ruby 

require 'spec_helper'

describe Note do
  before do
  end

  context "new" do
    it "should take a note and a duration" do
      Note.new(Pitch.new(0), Duration.new(0)).should be_an_instance_of Note
    end
  end

  context "pitch" do
    it "should return the pitch it was created with" do
      pitch_val = 10
      n = Note.new(Pitch.new(pitch_val), Duration.new(0))
      n.pitch.val.should be pitch_val
    end
  end

  context "duration" do
    it "should return the duration it was created with" do
      duration_val = 10
      n = Note.new(Pitch.new(0), Duration.new(duration_val))
      n.duration.val.should be duration_val
    end
  end

end
