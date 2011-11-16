#!/usr/bin/env ruby

require 'spec_helper'
	
describe NoteGenerator do
  before do
  end

  context ".get_critics" do
    it "should return an array containing critics" do
      ng = NoteGenerator.new
      critics = ng.get_critics
      critics.should be_an_instance_of Array
    end
    it "should return an array containing critics" do
      ng = NoteGenerator.new
      critics = ng.get_critics
      critics.each do |critic|
        critic.should be_a_kind_of Critic
      end
    end
  end

  context ".reset" do
    it "should cause the next pitch (the first in a seq) to be an observed starting pitch" do
      ng = NoteGenerator.new
      critics = ng.get_critics
      critics.each do |critic|
        critic.listen(Note.new(Pitch.new(50), Duration.new(1)))
        critic.listen(Note.new(Pitch.new(55), Duration.new(2)))
      end
      ng.reset
      ng.generate.pitch.val.should == 50
    end
    it "should cause the next duration (the first in a seq) to be an observed starting duration" do
      ng = NoteGenerator.new
      critics = ng.get_critics
      critics.each do |critic|
        critic.listen(Note.new(Pitch.new(50), Duration.new(1)))
        critic.listen(Note.new(Pitch.new(55), Duration.new(2)))
      end
      ng.reset
      ng.generate.duration.val.should == 1
    end
  end

  context ".generate" do
    it "should return a note" do
      ng = NoteGenerator.new
      critics = ng.get_critics
      critics.each do |critic|
        critic.listen(Note.new(Pitch.new(50), Duration.new(1)))
        critic.listen(Note.new(Pitch.new(55), Duration.new(2)))
      end
      ng.reset
      ng.generate.should be_an_instance_of Note
    end
  end
end
