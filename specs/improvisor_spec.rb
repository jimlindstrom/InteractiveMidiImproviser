#!/usr/bin/env ruby 

require 'spec_helper'

describe Improvisor do
  before do
  end

  context ".get_critics" do
    it "should return an array containing critics" do
      i = Improvisor.new
      critics = i.get_critics
      critics.should be_an_instance_of Array
    end
    it "should return an array containing critics" do
      i = Improvisor.new
      critics = i.get_critics
      critics.each do |critic|
        critic.should be_a_kind_of Critic
      end
    end
  end

  context ".generate" do
    before (:each) do
      @i = Improvisor.new
      critics = @i.get_critics
      critics.each do |critic|
        critic.reset
        critic.listen(Note.new(Pitch.new(100), Duration.new(1)))
        critic.listen(Note.new(Pitch.new(102), Duration.new(2)))
        critic.listen(Note.new(Pitch.new(104), Duration.new(4)))
      end
    end
    it "should return an array of notes" do
      response = @i.generate
      response.should be_an_instance_of NoteQueue
    end
  end
end
