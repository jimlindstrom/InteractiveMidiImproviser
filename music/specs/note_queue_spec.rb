# midi_event_queue_spec.rb

require 'spec_helper'

describe Music::NoteQueue do

  before(:each) do
  end

  describe ".tempo" do
    it "can be read and written" do
      nq = Music::NoteQueue.new
      nq.tempo = 250
      nq.tempo.should == 250
    end
  end
     
  describe ".to_event_queue" do
    it "raises an error if tempo has not been set" do
      nq = Music::NoteQueue.new
      expect { nq.to_event_queue }.to raise_error(ArgumentError)
    end
    it "returns a EventQueue" do
      nq = Music::NoteQueue.new
      nq.tempo = 100
      nq.to_event_queue.should be_an_instance_of Midi::EventQueue
    end
    it "converts each note into a note_on / note_off pair" do
      nq = Music::NoteQueue.new
      nq.tempo = 100
      nq.push Music::Note.new(Music::Pitch.new(1), Music::Duration.new(1))
      nq.push Music::Note.new(Music::Pitch.new(2), Music::Duration.new(4))
      nq.push Music::Note.new(Music::Pitch.new(3), Music::Duration.new(2))
      eq = nq.to_event_queue
      eq.map{ |x| x.message }.should == [Midi::Event::NOTE_ON, Midi::Event::NOTE_OFF]*3
    end
    it "correctly sets the pitches" do
      nq = Music::NoteQueue.new
      nq.tempo = 100
      nq.push Music::Note.new(Music::Pitch.new(1), Music::Duration.new(1))
      nq.push Music::Note.new(Music::Pitch.new(2), Music::Duration.new(4))
      nq.push Music::Note.new(Music::Pitch.new(3), Music::Duration.new(2))
      eq = nq.to_event_queue
      eq.map{ |x| x.pitch }.should == [1,1, 2,2, 3,3]
    end
    it "correctly sets the durations (with 100% duty cycle), with the given tempo" do
      nq = Music::NoteQueue.new
      nq.tempo = 100
      nq.push Music::Note.new(Music::Pitch.new(1), Music::Duration.new(1))
      nq.push Music::Note.new(Music::Pitch.new(2), Music::Duration.new(4))
      nq.push Music::Note.new(Music::Pitch.new(3), Music::Duration.new(2))
      eq = nq.to_event_queue
      eq.map{ |x| x.timestamp }.should == [0,100, 100,500, 500,700]
    end
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

  describe "tag_with_notes_left" do
    it "adds analysis to each note indicating how many notes follow it" do
      vector = $meter_vectors["Bring back my bonnie to me"]
      nq = vector[:note_queue]
      nq.tag_with_notes_left
      puts "x: " + nq.map { |n| n.analysis[:notes_left] }.inspect
      nq.map { |n| n.analysis[:notes_left] }[-6..-1].should == [ 5, 4, 3, 2, 1, 0 ]
    end
  end

  describe ".from_event_queue" do
    before (:each) do
      @test_events = [
        Midi::NoteOnEvent.new({
          :pitch     => 40,
          :velocity  => 100,
          :timestamp => 1000 }),
        Midi::NoteOffEvent.new({
          :pitch     => 40,
          :velocity  => 100,
          :timestamp => 2000 }),
  
        Midi::NoteOnEvent.new({
          :pitch     => 42,
          :velocity  => 100,
          :timestamp => 2000 }),
        Midi::NoteOffEvent.new({
          :pitch     => 42,
          :velocity  => 100,
          :timestamp => 3000 }),
  
        Midi::NoteOnEvent.new({
          :pitch     => 44,
          :velocity  => 100,
          :timestamp => 3000 }),
        Midi::NoteOffEvent.new({
          :pitch     => 44,
          :velocity  => 100,
          :timestamp => 4000 }) ]
      @evq = Midi::EventQueue.new
      @test_events.each { |e| @evq.enqueue e }
      @nq = Music::NoteQueue.from_event_queue(@evq)
    end

    it "returns a NoteQueue" do
      @nq.class.should == Music::NoteQueue
    end
    it "converts the event queue into notes with the correct pitches" do
      @nq.map { |x| x.pitch.val }.should == [40, 42, 44]
    end
    it "converts the event queue into notes with the correct quantized duration" do
      @nq.map { |x| x.duration.val }.should == [1, 1, 1]
    end
    it "calculates tempo" do
      @nq.tempo.should == 1000
    end
  end

end
