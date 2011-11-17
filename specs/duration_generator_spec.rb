#!/usr/bin/ruby env

require 'spec_helper'

describe DurationGenerator do
  before do
  end

  context ".get_critics" do
    it "should return an array containing critics" do
      pg = PitchGenerator.new
      critics = pg.get_critics
      critics.should be_an_instance_of Array
    end
    it "should return an array containing critics" do
      pg = PitchGenerator.new
      critics = pg.get_critics
      critics.each do |critic|
        critic.should be_a_kind_of Critic
      end
    end
  end

  context ".reset" do
    it "should cause the next duration (the first in a seq) to be an observed starting duration" do
      dg = DurationGenerator.new
      critics = dg.get_critics
      critics.each do |critic|
        critic.listen(Note.new(Pitch.new(0), Duration.new(1)))
        critic.listen(Note.new(Pitch.new(0), Duration.new(2)))
      end
      dg.reset
      dg.generate.val.should == 1
    end
  end

  context ".generate" do
    it "should return a duration" do
      dg = DurationGenerator.new
      critics = dg.get_critics
      critics.each do |critic|
        critic.listen(Note.new(Pitch.new(0), Duration.new(1)))
        critic.listen(Note.new(Pitch.new(0), Duration.new(2)))
      end
      dg.reset
      dg.generate.should be_an_instance_of Duration
    end
  end
end
