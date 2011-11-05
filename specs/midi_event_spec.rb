# midi_event_spec.rb

require 'midi/event'

describe Midi::Event do

  before(:each) do
  end
     
  describe "#initialize" do
    it "will accept nil options" do
      @event = Midi::Event.new(nil)
      @event.class.should == Midi::Event
    end
  end

  describe "#initialize" do
    it "raises an error if opts contains parameters other than :message, :pitch, :velocity, or :timestamp" do
      expect { @event = Midi::Event.new({ :abc => 145 }) }.to raise_error(ArgumentError)
    end
  end

  describe "#initialize" do
    it "takes in an options hash that may contain a NOTE_ON message" do
      @event = Midi::Event.new({ :message   => Midi::Event::NOTE_ON,
                                 :pitch     => 145,
                                 :velocity  =>  90,
                                 :timestamp =>   0  })
      @event.class.should == Midi::Event
    end
  end

end
