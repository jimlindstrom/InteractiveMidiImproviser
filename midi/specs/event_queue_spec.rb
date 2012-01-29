# midi_event_queue_spec.rb

require 'spec_helper'

describe Midi::EventQueue do

  describe ".enqueue" do
    it "raises an error if the new element is not a Midi::Event" do
      @evq = Midi::EventQueue.new
      expect { @evq.enqueue({:message=>[Midi::Event::NOTE_ON,40,100,0],:timestamp=>1000}) }.to raise_error(ArgumentError)
    end
  end
   
  describe ".length" do
    it "returns zero initially" do
      @evq = Midi::EventQueue.new
      @evq.length.should == 0
    end

    it "returns the number of events enqueued" do
      @evq = Midi::EventQueue.new
      @num_events=(rand*50).round
      @num_events.times do 
        @evq.enqueue(Midi::NoteOnEvent.new({
                       :pitch     => 40,
                       :velocity  => 100,
                       :timestamp => 1000 }))

      end
      @evq.length.should == @num_events
    end
  end

  describe ".clear" do
    it "dumps the queued events" do
      @evq = Midi::EventQueue.new
      @num_events=(rand*50).round
      @num_events.times do 
        @evq.enqueue(Midi::NoteOnEvent.new({
                       :pitch     => 40,
                       :velocity  => 100,
                       :timestamp => 1000 }))
      end
      @evq.clear
      @evq.enqueue(Midi::NoteOnEvent.new({
                     :pitch     => 40,
                     :velocity  => 100,
                     :timestamp => 1000 }))
      @evq.length.should == 1
    end
  end

  describe ".get_pitches" do
    it "should return an array of all the pitches" do
      @evq = Midi::EventQueue.new
      @evq.enqueue(Midi::NoteOnEvent.new( { :pitch => 40, :velocity => 100, :timestamp => 1000 }))
      @evq.enqueue(Midi::NoteOffEvent.new({ :pitch => 40, :velocity => 100, :timestamp => 2000 }))
      @evq.enqueue(Midi::NoteOnEvent.new( { :pitch => 50, :velocity => 100, :timestamp => 2000 }))
      @evq.enqueue(Midi::NoteOffEvent.new({ :pitch => 50, :velocity => 100, :timestamp => 3000 }))
      @evq.enqueue(Midi::NoteOnEvent.new( { :pitch => 60, :velocity => 100, :timestamp => 3000 }))
      @evq.enqueue(Midi::NoteOffEvent.new({ :pitch => 60, :velocity => 100, :timestamp => 4000 }))
      @evq.get_pitches.should == [40, 50, 60]
    end
  end

  describe ".get_interonset_intervals" do
    it "should return an array of the onset-to-onset timestamp deltas" do
      @evq = Midi::EventQueue.new
      @evq.enqueue(Midi::NoteOnEvent.new( { :pitch => 40, :velocity => 100, :timestamp => 1000 }))
      @evq.enqueue(Midi::NoteOffEvent.new({ :pitch => 40, :velocity => 100, :timestamp => 2000 }))
      @evq.enqueue(Midi::NoteOnEvent.new( { :pitch => 50, :velocity => 100, :timestamp => 2000 }))
      @evq.enqueue(Midi::NoteOffEvent.new({ :pitch => 50, :velocity => 100, :timestamp => 3000 }))
      @evq.enqueue(Midi::NoteOnEvent.new( { :pitch => 60, :velocity => 100, :timestamp => 3000 }))
      @evq.enqueue(Midi::NoteOffEvent.new({ :pitch => 60, :velocity => 100, :timestamp => 4000 }))
      @evq.get_interonset_intervals.should == [2000-1000,  3000-2000]
    end
  end

  describe ".get_last_duration" do
    it "should return the duration (note-on to note-off time) of the last note" do
      @evq = Midi::EventQueue.new
      @evq.enqueue(Midi::NoteOnEvent.new( { :pitch => 40, :velocity => 100, :timestamp => 1000 }))
      @evq.enqueue(Midi::NoteOffEvent.new({ :pitch => 40, :velocity => 100, :timestamp => 2000 }))
      @evq.enqueue(Midi::NoteOnEvent.new( { :pitch => 50, :velocity => 100, :timestamp => 2000 }))
      @evq.enqueue(Midi::NoteOffEvent.new({ :pitch => 50, :velocity => 100, :timestamp => 3000 }))
      @evq.enqueue(Midi::NoteOnEvent.new( { :pitch => 60, :velocity => 100, :timestamp => 3000 }))
      @evq.enqueue(Midi::NoteOffEvent.new({ :pitch => 60, :velocity => 100, :timestamp => 4000 }))
      @evq.get_last_duration.should == 1000
    end
  end

end
