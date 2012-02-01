# midi_event_queue_spec.rb

require 'spec_helper'

shared_examples "detects the meter" do |vector|
  before(:all) do
    @nq = vector[:note_queue]
    @success = @nq.detect_meter
  end
  it "detects the time signature" do
    @success.should == true
    @nq.meter.val.should == vector[:meter].val
  end
  it "detects the offset" do
    @success.should == true
    @nq.first.analysis[:beat_position].to_hash.inspect.should == vector[:first_beat_position].to_hash.inspect
  end
end

describe Music::NoteQueue do

  before(:each) do
  end

  describe ".beat_array" do
    before(:each) do
      @nq = Music::NoteQueue.new
      @nq.tempo = 100
      @nq.push Music::Note.new(Music::Pitch.new(1), Music::Duration.new(1))
      @nq.push Music::Note.new(Music::Pitch.new(2), Music::Duration.new(4))
      @nq.push Music::Note.new(Music::Pitch.new(3), Music::Duration.new(2))
    end
    it "returns an array containing one element per beat" do
      @nq.beat_array.length.should == (1+4+2)
    end
    it "returns an array containing Notes where there are note onsets" do
      @nq.beat_array[0+1+4].nil?.should be_false
    end
    it "returns an array containing nils where there aren't note onsets" do
      @nq.beat_array[0+2].nil?.should be_true
    end
    
  end

  describe ".detect_meter" do
    context "when the note queue is metrically clear" do
      before(:each) do
        vector = $meter_vectors["Bring back my bonnie to me"]
        @nq = vector[:note_queue]
      end
      it "returns true" do
        @nq.detect_meter.should == true
      end
    end
    context "when the note queue is metrically ambiguous" do
      before(:each) do
        vector = $meter_vectors["Bring back my bonnie to me"]
        nq = vector[:note_queue]
        @nq = nq[0..0] # something so short it's guaranteed to be metrically ambiguous
      end
      it "returns false" do
        @nq.detect_meter.should == false
      end
    end
    context "if the note queue contains rests" do
      before(:each) do
        @nq = Music::NoteQueue.new
        @nq.tempo = 100
        @nq.push Music::Note.new(Music::Pitch.new(1), Music::Duration.new(1))
        @nq.push Music::Note.new(Music::Pitch.new(2), Music::Duration.new(4))
        @nq.push Music::Rest.new(                     Music::Duration.new(3))
        @nq.push Music::Note.new(Music::Pitch.new(3), Music::Duration.new(2))
      end
      it "returns false" do
        @nq.detect_meter.should == false
      end
    end

  end


  describe ".detect_meter" do
    context "my bonnie lies...", :known_fail=>true do
      it_should_behave_like "detects the meter", $meter_vectors["Bring back my bonnie to me"]
    end
    context "battle hymn..." do
      it_should_behave_like "detects the meter", $meter_vectors["Battle hymn of the republic"]
    end
    context "bach minuet..." do
      it_should_behave_like "detects the meter", $meter_vectors["Bach Minuet in G"]
    end
    context "somewhere over...", :known_fail=>true do
      it_should_behave_like "detects the meter", $meter_vectors["Somewhere over the rainbow"]
    end
    context "this train...", :known_fail=>true do
      it_should_behave_like "detects the meter", $meter_vectors["This train is bound for glory"]
    end
    context "bach minuet 2..." do
      it_should_behave_like "detects the meter", $meter_vectors["Bach Minuet (2)"]
    end
    context "amazing grace...", :known_fail=>true do
      it_should_behave_like "detects the meter", $meter_vectors["Amazing Grace"]
    end
    context "ode to joy...", :known_fail=>true do
      it_should_behave_like "detects the meter", $meter_vectors["Ode to Joy"]
    end
    context "auld lang syne", :known_fail=>true do
      it_should_behave_like "detects the meter", $meter_vectors["Auld Lang Syne"]
    end
    context "oh my darling clementine", :known_fail=>true do
      it_should_behave_like "detects the meter", $meter_vectors["Clementine"]
    end
    context "when the saints..." do
      #it_should_behave_like "detects the meter", $meter_vectors["When the Saints"]
      pending "Can't handle rests in the note queue yet"
    end
  end

end
