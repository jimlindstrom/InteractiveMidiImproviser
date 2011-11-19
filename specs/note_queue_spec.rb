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

  describe "detect_meter" do
    it "detects the time signature (my bonnie lies...)" do
      vector = $meter_vectors["Bring back my bonnie to me"]
      nq = vector[:note_queue]
      nq.detect_meter
      nq.meter[:time_sig].should   == vector[:time_sig]
      nq.meter[:multiplier].should == vector[:multiplier]
      nq.meter[:offset].should     == vector[:offset]
    end
    it "detects the time signature (battle hymn...)" do
      vector = $meter_vectors["Battle hymn of the republic"]
      nq = vector[:note_queue]
      nq.detect_meter
      nq.meter[:time_sig].should   == vector[:time_sig]
      nq.meter[:multiplier].should == vector[:multiplier]
      nq.meter[:offset].should     == vector[:offset]
    end
    it "detects the time signature (Minuet...)" do
      vector = $meter_vectors["Bach Minuet in G"]
      nq = vector[:note_queue]
      nq.detect_meter
      nq.meter[:time_sig].should   == vector[:time_sig]
      nq.meter[:multiplier].should == vector[:multiplier]
      nq.meter[:offset].should     == vector[:offset]
    end
    it "detects the time signature (somewhere over...)" do
      vector = $meter_vectors["Somewhere over the rainbow"]
      nq = vector[:note_queue]
      nq.detect_meter
      nq.meter[:time_sig].should   == vector[:time_sig]
      nq.meter[:multiplier].should == vector[:multiplier]
      nq.meter[:offset].should     == vector[:offset]
    end

  end

end
