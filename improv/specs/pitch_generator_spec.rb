#!/usr/bin/env ruby 

require 'spec_helper'

describe PitchGenerator do
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
    it "should cause the next pitch (the first in a seq) to be an observed starting pitch" do
      pg = PitchGenerator.new
      critics = pg.get_critics
      critics.each do |critic|
        critic.listen(Music::Note.new(Music::Pitch.new(50), Music::Duration.new(1)))
        critic.listen(Music::Note.new(Music::Pitch.new(55), Music::Duration.new(1)))
      end
      pg.reset
      pg.generate.val.should == 50
    end
  end

  context ".generate" do
    it "should return a pitch" do
      pg = PitchGenerator.new
      critics = pg.get_critics
      critics.each do |critic|
        critic.listen(Music::Note.new(Music::Pitch.new(50), Music::Duration.new(1)))
        critic.listen(Music::Note.new(Music::Pitch.new(55), Music::Duration.new(1)))
      end
      pg.reset
      pg.generate.should be_an_instance_of Music::Pitch
    end
  end
end
