# midi_event_queue_spec.rb

require 'midi/event_queue'

describe Midi::EventQueue do

  before(:each) do
  end
    
  describe "#length" do
    it "returns zero initially" do
      @evq = Midi::EventQueue.new
      @evq.length.should == 0
    end
  end

  describe "#length" do
    it "returns the number of events enqueued" do
      @evq = Midi::EventQueue.new
      @num_events=(rand*50).round
      @num_events.times do 
        @evq.enqueue({:message=>[144,40,100,0],:timestamp=>1000})
      end
      @evq.length.should == @num_events
    end
  end

  describe "#clear" do
    it "dumps the queued events" do
      @evq = Midi::EventQueue.new
      @num_events=(rand*50).round
      @num_events.times do 
        @evq.enqueue({:message=>[144,40,100,0],:timestamp=>1000})
      end
      @evq.clear
      @evq.enqueue({:message=>[144,40,100,0],:timestamp=>1000})
      @evq.length.should == 1
    end
  end

  describe "#get_pitches" do
    it "returns an array of durations (integers) corresponding to each of the events" do
      @evq = Midi::EventQueue.new
      5.times do 
        @evq.enqueue({:message=>[144,40,100,0],:timestamp=>1000})
      end
      @evq.get_pitches.should == [40]*5
    end
  end

  describe "#get_interonset_intervals" do
    it "returns an IOIArray" do
      @evq = Midi::EventQueue.new
      @evq.enqueue({:message=>[144,40,100,0],:timestamp=>1000})
      @evq.enqueue({:message=>[128,40,100,0],:timestamp=>2000})
      @evq.enqueue({:message=>[144,40,100,0],:timestamp=>2000})
      @evq.enqueue({:message=>[128,40,100,0],:timestamp=>3000})
      @evq.enqueue({:message=>[144,40,100,0],:timestamp=>3000})
      @evq.enqueue({:message=>[128,40,100,0],:timestamp=>4000})
      @evq.get_interonset_intervals.class.should == Midi::IOIArray
    end
  end

  describe "#get_interonset_intervals" do
    it "returns an array containing the interonset intervals (in msec) between successive notes" do
      @evq = Midi::EventQueue.new
      @evq.enqueue({:message=>[144,40,100,0],:timestamp=>1000})
      @evq.enqueue({:message=>[128,40,100,0],:timestamp=>2000})
      @evq.enqueue({:message=>[144,40,100,0],:timestamp=>2000})
      @evq.enqueue({:message=>[128,40,100,0],:timestamp=>3000})
      @evq.enqueue({:message=>[144,40,100,0],:timestamp=>3000})
      @evq.enqueue({:message=>[128,40,100,0],:timestamp=>4000})
      @evq.get_interonset_intervals.should == [1000,1000]
    end
  end

end
