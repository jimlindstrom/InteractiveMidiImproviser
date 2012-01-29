# midi_event_queue_spec.rb

require 'spec_helper'

shared_examples "detects phrases" do |vector|
  it "detects the phrase onsets" do
    nq = vector[:note_queue]
    nq.detect_phrases
    nq.phrases.collect{|p| p.start_idx }.should == vector[:phrase_boundaries].collect{|p| p[:start_idx] }
  end
end

describe Music::NoteQueue do

  before(:each) do
  end

  describe ".detect_phrases", :high_level_stats=>true do
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

    it "should include all actual boundary candidates" do
      pct_found = @true_pos / @exp_true_pos.to_f
      pct_found.should be_within(0.05).of(1.0)
    end
    it "should not include wrong boundary candidates" do
      pct_extra = @false_pos / @exp_true_pos.to_f
      pct_extra.should be_within(0.05).of(0.0)
    end
  end

  describe ".detect_phrases" do
    before(:each) do
      @vector = $phrasing_vectors["Bring back my bonnie to me"]
      @nq = @vector[:note_queue]
    end
    context "when the note queue is metrically clear" do
      it "returns true" do
        @nq.detect_phrases.should == true
      end
    end
    context "when the note queue is metrically ambiguous" do
      it "returns false" do
        @nq = @nq[0..0] # something so short it's guaranteed to be metrically ambiguous
        @nq.detect_phrases.should == false
      end
    end
  end

  describe ".detect_phrases" do
    context "my bonnie lies..." do
      it_should_behave_like "detects phrases", $phrasing_vectors["Bring back my bonnie to me"]
    end
    context "battle hymn..." do
      it_should_behave_like "detects phrases", $phrasing_vectors["Battle hymn of the republic"]
    end
    context "bach minuet..." do
      it_should_behave_like "detects phrases", $phrasing_vectors["Bach Minuet in G"]
    end
    context "somewhere over..." do
      it_should_behave_like "detects phrases", $phrasing_vectors["Somewhere over the rainbow"]
    end
    context "this train..." do
      it_should_behave_like "detects phrases", $phrasing_vectors["This train is bound for glory"]
    end
    context "bach minuet 2..." do
      it_should_behave_like "detects phrases", $phrasing_vectors["Bach Minuet (2)"]
    end
    context "amazing grace..." do
      it_should_behave_like "detects phrases", $phrasing_vectors["Amazing Grace"]
    end
    context "ode to joy..." do
      it_should_behave_like "detects phrases", $phrasing_vectors["Ode to Joy"]
    end
    context "auld lang syne" do
      it_should_behave_like "detects phrases", $phrasing_vectors["Auld Lang Syne"]
    end
    context "oh my darling clementine" do
      it_should_behave_like "detects phrases", $phrasing_vectors["Clementine"]
    end
  end

end
