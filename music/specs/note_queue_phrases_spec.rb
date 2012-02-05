# midi_event_queue_spec.rb

require 'spec_helper'

describe Music::NoteQueue do

  before(:each) do
  end

  describe ".detect_phrases" do
    before(:each) do
      @vector = $phrasing_vectors["Bring back my bonnie to me"]
      @nq = @vector[:note_queue]
    end
    context "when the note queue is clearly phrased", :known_fail=>true do
      it "returns true" do
        @nq.detect_phrases.should == true
      end
    end
    context "when the note queue is ambiguously phrased" do
      it "returns false" do
        @nq = @nq[0..0] # something so short it's guaranteed to be metrically ambiguous
        @nq.detect_phrases.should == false
      end
    end
    context "when the note queue contains rests" do
      before(:each) do
        @nq = Music::NoteQueue.new
        @nq.tempo = 100
        @nq.push Music::Note.new(Music::Pitch.new(1), Music::Duration.new(1))
        @nq.push Music::Note.new(Music::Pitch.new(2), Music::Duration.new(4))
        @nq.push Music::Rest.new(                     Music::Duration.new(3))
        @nq.push Music::Note.new(Music::Pitch.new(3), Music::Duration.new(2))
      end
      it "returns false" do
        @nq.detect_phrases.should == false
      end
    end
  end

  describe ".detect_phrases", :high_level_stats=>true do
    before(:all) do
      @false_pos    = 0
      @false_neg    = 0
      @true_pos     = 0
      @exp_true_pos = 0

      @successes = []
      @failures  = []

      $phrasing_vectors.keys.sort.each do |key|
        $log.info "\tTrying to detect phrases for: #{key}" if $log
        vector = $phrasing_vectors[key]
        nq = vector[:note_queue]
        success = nq.detect_phrases

        actual_boundaries = vector[:phrase_boundaries].collect{ |p| p[:start_idx] }
        calced_boundaries = nq.phrases.collect{ |p| p.start_idx } if  success
        calced_boundaries = []                                    if !success

        @false_pos    += (calced_boundaries - actual_boundaries).length # switch to using actual boundaries
        @false_neg    += (actual_boundaries - calced_boundaries).length
        @true_pos     += (actual_boundaries & calced_boundaries).length
        @exp_true_pos += actual_boundaries.length

        if success and (calced_boundaries == actual_boundaries)
          @successes.push "#{key}"
        elsif success and (calced_boundaries != actual_boundaries)
          @failures.push "%-34s" % "\"#{key}\"" +
                         "calculated: #{calced_boundaries.inspect} != expected: #{actual_boundaries.inspect}"
        else # !success
          @failures.push "%-34s" % "\"#{key}\"" +
                         "failed"
        end
      end

      if @failures.length > 0 and $log
        $log.info "\n" +
                  "\tsuccesses:\n" + 
                  "\t\t" + @successes.join("\n\t\t") +
                  "\n" +
                  "\tfailures:\n" +
                  "\t\t" + @failures.join("\n\t\t")
      end
    end

    it "should produce the expected phrase list > 50% of the time" do
      pct_success = @successes.length / $phrasing_vectors.keys.length.to_f
      pct_success.should be > 0.50
    end
    it "should include 95% of all actual boundary candidates" do
      pct_found = @true_pos / @exp_true_pos.to_f
      pct_found.should be > 0.95 
    end
    it "should include wrong boundary candidates less than 5% of the time" do
      pct_extra = @false_pos / @exp_true_pos.to_f
      pct_extra.should be < 0.05
    end
  end

end
