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
        @evq.enqueue(Midi::Event.new({:message   => Midi::Event::NOTE_ON,
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
        @evq.enqueue(Midi::Event.new({:message   => Midi::Event::NOTE_ON,
                                      :pitch     => 40,
                                      :velocity  => 100,
                                      :timestamp => 1000 }))
      end
      @evq.clear
      @evq.enqueue(Midi::Event.new({:message   => Midi::Event::NOTE_ON,
                                    :pitch     => 40,
                                    :velocity  => 100,
                                    :timestamp => 1000 }))
      @evq.length.should == 1
    end
  end

end
