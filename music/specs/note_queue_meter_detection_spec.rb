# midi_event_queue_spec.rb

require 'spec_helper'

describe Music::NoteQueue do

  before(:each) do
  end

  describe "beat_array" do
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

  describe "detect_meter" do
    it "returns true if it's confident about the detected meter" do
      vector = $meter_vectors["Bring back my bonnie to me"]
      nq = vector[:note_queue]
      nq.detect_meter.should == true
    end
    it "returns false if it's not confident about the detected meter" do
      vector = $meter_vectors["Bring back my bonnie to me"]
      nq = vector[:note_queue]
      nq = nq[0..0] # something so short it's guaranteed to be metrically ambiguous
      nq.detect_meter.should == false
    end

    it "detects the time signature (my bonnie lies...)" do
      vector = $meter_vectors["Bring back my bonnie to me"]
      nq = vector[:note_queue]
      nq.detect_meter
      nq.meter.val.should == vector[:meter].val
    end
    it "detects the offset (my bonnie lies...)" do
      vector = $meter_vectors["Bring back my bonnie to me"]
      nq = vector[:note_queue]
      nq.detect_meter
      nq.first.analysis[:beat_position].to_hash.inspect.should == vector[:first_beat_position].to_hash.inspect
    end

    it "detects the time signature (battle hymn...)" do
      vector = $meter_vectors["Battle hymn of the republic"]
      nq = vector[:note_queue]
      nq.detect_meter
      nq.meter.val.should == vector[:meter].val
    end
    it "detects the offset (battle hymn...)" do
      vector = $meter_vectors["Battle hymn of the republic"]
      nq = vector[:note_queue]
      nq.detect_meter
      nq.first.analysis[:beat_position].to_hash.inspect.should == vector[:first_beat_position].to_hash.inspect
    end

    it "detects the time signature (minuet...)" do
      vector = $meter_vectors["Bach Minuet in G"]
      nq = vector[:note_queue]
      nq.detect_meter
      nq.meter.val.should == vector[:meter].val
    end
    it "detects the offset (minuet...)" do
      vector = $meter_vectors["Bach Minuet in G"]
      nq = vector[:note_queue]
      nq.detect_meter
      nq.first.analysis[:beat_position].to_hash.inspect.should == vector[:first_beat_position].to_hash.inspect
    end

    it "detects the time signature (minuet (2)...)" do
      vector = $meter_vectors["Bach Minuet (2)"]
      nq = vector[:note_queue]
      nq.detect_meter
      nq.meter.val.should == vector[:meter].val
    end
    it "detects the offset (minuet (2)...)" do
      vector = $meter_vectors["Bach Minuet (2)"]
      nq = vector[:note_queue]
      nq.detect_meter
      nq.first.analysis[:beat_position].to_hash.inspect.should == vector[:first_beat_position].to_hash.inspect
    end

    it "detects the time signature (somewhere over...)" do
      vector = $meter_vectors["Somewhere over the rainbow"]
      nq = vector[:note_queue]
      nq.detect_meter
      #nq.meter.val.should == vector[:meter].val
      pending("This one doesn't work yet...")
    end
    it "detects the offset (somewhere over...)" do
      vector = $meter_vectors["Somewhere over the rainbow"]
      nq = vector[:note_queue]
      nq.detect_meter
      nq.first.analysis[:beat_position].to_hash.inspect.should == vector[:first_beat_position].to_hash.inspect
    end

    it "detects the time signature (this train...)" do
      vector = $meter_vectors["This train is bound for glory"]
      nq = vector[:note_queue]
      nq.detect_meter
      #nq.meter.val.should == vector[:meter].val
      pending("This one doesn't work yet...")
    end
    it "detects the offset (this train...)" do
      vector = $meter_vectors["This train is bound for glory"]
      nq = vector[:note_queue]
      nq.detect_meter
      nq.first.analysis[:beat_position].to_hash.inspect.should == vector[:first_beat_position].to_hash.inspect
    end
  end

end
