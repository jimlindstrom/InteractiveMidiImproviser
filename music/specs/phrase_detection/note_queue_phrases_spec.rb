# midi_event_queue_spec.rb

require 'spec_helper'

describe Music::NoteQueue do

  before(:each) do
  end

  describe "detect_phrases", :high_level_stats=>true do
    before(:all) do
      @false_pos    = 0
      @false_neg    = 0
      @true_pos     = 0
      @exp_true_pos = 0

      $phrasing_vectors.keys.each do |key|
        vector = $phrasing_vectors[key]
        nq = vector[:note_queue]
        nq.detect_phrases

        actual_boundaries = vector[:phrase_boundaries].collect{ |p| p[:start_idx] }
        calced_boundaries = nq.phrases.collect{ |p| p.start_idx }

        @false_pos    += (calced_boundaries - actual_boundaries).length # switch to using actual boundaries
        @false_neg    += (actual_boundaries - calced_boundaries).length
        @true_pos     += (actual_boundaries & calced_boundaries).length
        @exp_true_pos += actual_boundaries.length
      end
    end

    it "should only include actual boundary candidates" do
      pct_found = @true_pos / @exp_true_pos.to_f
      pct_found.should be_within(0.10).of(1.0)
    end
    it "should only include actual boundary candidates" do
      pct_extra = @false_pos / @exp_true_pos.to_f
      pct_extra.should be_within(0.10).of(0.0)
    end
  end

  describe "detect_phrases" do
    it "returns true if it's confident about the detected phrases" do
      vector = $phrasing_vectors["Bring back my bonnie to me"]
      nq = vector[:note_queue]
      nq.detect_phrases.should == true
    end
    it "returns false if it's not confident about the detected phrases" do
      vector = $phrasing_vectors["Bring back my bonnie to me"]
      nq = vector[:note_queue]
      nq = nq[0..0] # something so short it's guaranteed to be metrically ambiguous
      nq.detect_phrases.should == false
    end

    it "detects the phrase onsets (my bonnie lies...)" do
      vector = $phrasing_vectors["Bring back my bonnie to me"]
      nq = vector[:note_queue]
      nq.detect_phrases
      nq.phrases.collect{|p| p.start_idx }.should == vector[:phrase_boundaries].collect{|p| p[:start_idx] }
    end
    it "detects the phrase onsets (battle hymn...)" do
      vector = $phrasing_vectors["Battle hymn of the republic"]
      nq = vector[:note_queue]
      nq.detect_phrases
      nq.phrases.collect{|p| p.start_idx }.should == vector[:phrase_boundaries].collect{|p| p[:start_idx] }
    end
    it "detects the phrase onsets (bach minuet...)" do
      vector = $phrasing_vectors["Bach Minuet in G"]
      nq = vector[:note_queue]
      nq.detect_phrases
      nq.phrases.collect{|p| p.start_idx }.should == vector[:phrase_boundaries].collect{|p| p[:start_idx] }
    end
    it "detects the phrase onsets (somewhere over...)" do
      vector = $phrasing_vectors["Somewhere over the rainbow"]
      nq = vector[:note_queue]
      nq.detect_phrases
      nq.phrases.collect{|p| p.start_idx }.should == vector[:phrase_boundaries].collect{|p| p[:start_idx] }
    end
    it "detects the phrase onsets (this train...)" do
      vector = $phrasing_vectors["This train is bound for glory"]
      nq = vector[:note_queue]
      nq.detect_phrases
      nq.phrases.collect{|p| p.start_idx }.should == vector[:phrase_boundaries].collect{|p| p[:start_idx] }
    end
    it "detects the phrase onsets (bach minuet 2...)" do
      vector = $phrasing_vectors["Bach Minuet (2)"]
      nq = vector[:note_queue]
      nq.detect_phrases
      nq.phrases.collect{|p| p.start_idx }.should == vector[:phrase_boundaries].collect{|p| p[:start_idx] }
    end
  end

end
