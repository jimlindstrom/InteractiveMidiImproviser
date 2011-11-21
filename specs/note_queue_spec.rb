# midi_event_queue_spec.rb

require 'spec_helper'

describe NoteQueue do

  before(:each) do
  end

  describe ".tempo" do
    it "can be read and written" do
      nq = NoteQueue.new
      nq.tempo = 250
      nq.tempo.should == 250
    end
  end
     
  describe ".to_event_queue" do
    it "raises an error if tempo has not been set" do
      nq = NoteQueue.new
      expect { nq.to_event_queue }.to raise_error(ArgumentError)
    end
    it "returns a EventQueue" do
      nq = NoteQueue.new
      nq.tempo = 100
      nq.to_event_queue.should be_an_instance_of Midi::EventQueue
    end
    it "converts each note into a note_on / note_off pair" do
      nq = NoteQueue.new
      nq.tempo = 100
      nq.push Note.new(Pitch.new(1), Duration.new(1))
      nq.push Note.new(Pitch.new(2), Duration.new(4))
      nq.push Note.new(Pitch.new(3), Duration.new(2))
      eq = nq.to_event_queue
      eq.map{ |x| x.message }.should == [Midi::Event::NOTE_ON, Midi::Event::NOTE_OFF]*3
    end
    it "correctly sets the pitches" do
      nq = NoteQueue.new
      nq.tempo = 100
      nq.push Note.new(Pitch.new(1), Duration.new(1))
      nq.push Note.new(Pitch.new(2), Duration.new(4))
      nq.push Note.new(Pitch.new(3), Duration.new(2))
      eq = nq.to_event_queue
      eq.map{ |x| x.pitch }.should == [1,1, 2,2, 3,3]
    end
    it "correctly sets the durations (with 100% duty cycle), with the given tempo" do
      nq = NoteQueue.new
      nq.tempo = 100
      nq.push Note.new(Pitch.new(1), Duration.new(1))
      nq.push Note.new(Pitch.new(2), Duration.new(4))
      nq.push Note.new(Pitch.new(3), Duration.new(2))
      eq = nq.to_event_queue
      eq.map{ |x| x.timestamp }.should == [0,100, 100,500, 500,700]
    end
  end

  describe "beat_array" do
    before(:each) do
      @nq = NoteQueue.new
      @nq.tempo = 100
      @nq.push Note.new(Pitch.new(1), Duration.new(1))
      @nq.push Note.new(Pitch.new(2), Duration.new(4))
      @nq.push Note.new(Pitch.new(3), Duration.new(2))
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
      nq.meter.val.should == vector[:meter].val
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
      nq.meter.val.should == vector[:meter].val
    end
    it "detects the offset (this train...)" do
      vector = $meter_vectors["This train is bound for glory"]
      nq = vector[:note_queue]
      nq.detect_meter
      nq.first.analysis[:beat_position].to_hash.inspect.should == vector[:first_beat_position].to_hash.inspect
    end

  end

end
