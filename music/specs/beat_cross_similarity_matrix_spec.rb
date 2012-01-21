#!/usr/bin/env ruby 

require 'spec_helper'

describe Music::BeatCrossSimilarityMatrix do
  context "new" do
    before(:each) do
      vector = $phrasing_vectors["Bring back my bonnie to me"]
      nq = vector[:note_queue]
      @beat_array1 = nq.beat_array
  
      vector = $phrasing_vectors["This train is bound for glory"]
      nq = vector[:note_queue]
      @beat_array2 = nq.beat_array
    end
    it "should take two beat arrays and return a cross similarity matrix" do
      Music::BeatCrossSimilarityMatrix.new(@beat_array1, @beat_array2).should be_an_instance_of Music::BeatCrossSimilarityMatrix
    end
  end

  context "max_arithmetic_mean_of_diag" do

    context "this train" do
      before(:all) do
        @vector = $phrasing_vectors["This train is bound for glory"]
        @nq = @vector[:note_queue]
        @nq.create_intervals

        @correct_pl = Music::PhraseList.new(@nq)
        @vector[:phrase_boundaries].each do |p|
          @correct_pl.push Music::Phrase.new(@nq, p[:start_idx], p[:end_idx])
        end

        @incorrect_pl = Music::PhraseList.new(@nq)
        @incorrect_pl.push Music::Phrase.new(@nq, 10, 16)
        @incorrect_pl.push Music::Phrase.new(@nq, 12, 18)
        @incorrect_pl.push Music::Phrase.new(@nq, 17, 25)
      end

      it "should return >= 25% higher similarity for real phrases than for fake phrases (this train 1)" do
        beat_array1 = Music::NoteQueue.new(  @correct_pl[0].notes).beat_array
        beat_array2 = Music::NoteQueue.new(  @correct_pl[1].notes).beat_array
        beat_array3 = Music::NoteQueue.new(@incorrect_pl[0].notes).beat_array
  
        m12 = Music::BeatCrossSimilarityMatrix.new(beat_array1, beat_array2)
        m23 = Music::BeatCrossSimilarityMatrix.new(beat_array2, beat_array3)
  
        s12 = m12.max_arithmetic_mean_of_diag 
        s23 = m23.max_arithmetic_mean_of_diag 
  
        s12.should be >= 1.25*s23
      end

      it "should return >= 25% higher similarity for real phrases than for fake phrases (this train 2)" do
        beat_array1 = Music::NoteQueue.new(  @correct_pl[0].notes).beat_array
        beat_array2 = Music::NoteQueue.new(  @correct_pl[3].notes).beat_array
        beat_array3 = Music::NoteQueue.new(@incorrect_pl[1].notes).beat_array
  
        m12 = Music::BeatCrossSimilarityMatrix.new(beat_array1, beat_array2)
        m23 = Music::BeatCrossSimilarityMatrix.new(beat_array2, beat_array3)
  
        s12 = m12.max_arithmetic_mean_of_diag 
        s23 = m23.max_arithmetic_mean_of_diag 
  
        s12.should be >= 1.25*s23
      end

      it "should return >= 25% higher similarity for real phrases than for fake phrases (this train 3)" do
        beat_array1 = Music::NoteQueue.new(  @correct_pl[1].notes).beat_array
        beat_array2 = Music::NoteQueue.new(  @correct_pl[3].notes).beat_array
        beat_array3 = Music::NoteQueue.new(@incorrect_pl[2].notes).beat_array
  
        m12 = Music::BeatCrossSimilarityMatrix.new(beat_array1, beat_array2)
        m23 = Music::BeatCrossSimilarityMatrix.new(beat_array2, beat_array3)
  
        s12 = m12.max_arithmetic_mean_of_diag 
        s23 = m23.max_arithmetic_mean_of_diag 
  
        s12.should be >= 1.25*s23
      end
    end

    context "somewhere over" do
      before(:all) do
        @vector = $phrasing_vectors["Somewhere over the rainbow"]
        @nq = @vector[:note_queue]
        @nq.create_intervals

        @correct_pl = Music::PhraseList.new(@nq)
        @vector[:phrase_boundaries].each do |p|
          @correct_pl.push Music::Phrase.new(@nq, p[:start_idx], p[:end_idx])
        end

        @incorrect_pl = Music::PhraseList.new(@nq)
        @incorrect_pl.push Music::Phrase.new(@nq,  2,  8)
        @incorrect_pl.push Music::Phrase.new(@nq,  9, 11)
        @incorrect_pl.push Music::Phrase.new(@nq, 12, 21)
      end

      it "should return >= 25% higher similarity for real phrases than for fake phrases (somewhere 1)" do
        beat_array1 = Music::NoteQueue.new(  @correct_pl[0].notes).beat_array
        beat_array2 = Music::NoteQueue.new(  @correct_pl[1].notes).beat_array
        beat_array3 = Music::NoteQueue.new(@incorrect_pl[0].notes).beat_array
  
        m12 = Music::BeatCrossSimilarityMatrix.new(beat_array1, beat_array2)
        m23 = Music::BeatCrossSimilarityMatrix.new(beat_array2, beat_array3)
  
        s12 = m12.max_arithmetic_mean_of_diag 
        s23 = m23.max_arithmetic_mean_of_diag 
  
        s12.should be >= 1.25*s23
      end

      it "should return >= 25% higher similarity for real phrases than for fake phrases (somewhere 2)" do
        beat_array1 = Music::NoteQueue.new(  @correct_pl[0].notes).beat_array
        beat_array2 = Music::NoteQueue.new(  @correct_pl[3].notes).beat_array
        beat_array3 = Music::NoteQueue.new(@incorrect_pl[1].notes).beat_array
  
        m12 = Music::BeatCrossSimilarityMatrix.new(beat_array1, beat_array2)
        m23 = Music::BeatCrossSimilarityMatrix.new(beat_array2, beat_array3)
  
        s12 = m12.max_arithmetic_mean_of_diag 
        s23 = m23.max_arithmetic_mean_of_diag 
  
        s12.should be >= 1.25*s23
      end

      it "should return >= 25% higher similarity for real phrases than for fake phrases (somewhere 3)" do
        beat_array1 = Music::NoteQueue.new(  @correct_pl[1].notes).beat_array
        beat_array2 = Music::NoteQueue.new(  @correct_pl[2].notes).beat_array
        beat_array3 = Music::NoteQueue.new(@incorrect_pl[2].notes).beat_array
  
        m12 = Music::BeatCrossSimilarityMatrix.new(beat_array1, beat_array2)
        m23 = Music::BeatCrossSimilarityMatrix.new(beat_array2, beat_array3)
  
        s12 = m12.max_arithmetic_mean_of_diag 
        s23 = m23.max_arithmetic_mean_of_diag 
  
        s12.should be >= 1.25*s23
      end
    end

  end

end
