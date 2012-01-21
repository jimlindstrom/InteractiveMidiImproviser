#!/usr/bin/env ruby 

require 'spec_helper'

describe Music::BeatCrossSimilarityMatrix do
  before(:each) do
    vector = $phrasing_vectors["Bring back my bonnie to me"]
    nq = vector[:note_queue]
    @beat_array1 = nq.beat_array

    vector = $phrasing_vectors["This train is bound for glory"]
    nq = vector[:note_queue]
    @beat_array2 = nq.beat_array
  end

  context "new" do
    it "should take two beat arrays and return a cross similarity matrix" do
      Music::BeatCrossSimilarityMatrix.new(@beat_array1, @beat_array2).should be_an_instance_of Music::BeatCrossSimilarityMatrix
    end
  end

end
