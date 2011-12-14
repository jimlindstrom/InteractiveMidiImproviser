#!/usr/bin/env ruby 

require 'spec_helper'

describe Music::Note do
  before do
  end

  context "new" do
    it "should take a note and a duration" do
      Music::Note.new(Music::Pitch.new(0), Music::Duration.new(0)).should be_an_instance_of Music::Note
    end
  end

  context "pitch" do
    it "should return the pitch it was created with" do
      pitch_val = 10
      n = Music::Note.new(Music::Pitch.new(pitch_val), Music::Duration.new(0))
      n.pitch.val.should be pitch_val
    end
  end

  context "duration" do
    it "should return the duration it was created with" do
      duration_val = 10
      n = Music::Note.new(Music::Pitch.new(0), Music::Duration.new(duration_val))
      n.duration.val.should be duration_val
    end
  end

  context "analysis" do
    it "should return a hash that can be extended with whatever values critics want" do
      n = Music::Note.new(Music::Pitch.new(0), Music::Duration.new(3))
      n.analysis.should be_an_instance_of Hash
    end
  end

end
