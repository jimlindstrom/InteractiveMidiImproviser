# midi_event_spec.rb

require 'spec_helper'

describe Midi::Event do
     
  describe ".initialize" do
    it "takes a message and a timestamp, and creates a new Midi::Event" do
      @event = Midi::Event.new(message=Midi::Event::NOTE_ON, timestamp=123)
      @event.should be_an_instance_of Midi::Event
    end
    it "raises an error if the Midi event isn't valid" do
      expect { @event = Midi::Event.new(message=-1, timestamp=0) }.to raise_error(ArgumentError)
    end
    it "raises an error if the timestamp is negative" do
      expect { @event = Midi::Event.new(message=Midi::Event::NOTE_ON, timestamp=-1) }.to raise_error(ArgumentError)
    end
  end
      
  describe ".message" do
    it "returns whatever you initialized it to" do
      @event = Midi::Event.new(message=Midi::Event::NOTE_ON, timestamp=123)
      @event.message.should == Midi::Event::NOTE_ON
    end
  end

  describe ".timestamp" do
    it "returns whatever you initialized it to" do
      @event = Midi::Event.new(message=Midi::Event::NOTE_ON, timestamp=123)
      @event.timestamp.should == 123
    end
  end

end

describe Midi::NoteEvent do
  describe ".initialize" do
    pending
  end
       
  describe ".pitch" do
    pending
  end
     
  describe ".velocity" do
    pending
  end
end

describe Midi::NoteOnEvent do
  describe ".initialize" do
    pending
  end
end

describe Midi::NoteOffEvent do
  describe ".initialize" do
    pending
  end
end

describe Midi::KeySigEvent do
  describe ".initialize" do
    pending
  end

  describe ".num_flats" do
    pending
  end

  describe ".is_major" do
    pending
  end
end

