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
