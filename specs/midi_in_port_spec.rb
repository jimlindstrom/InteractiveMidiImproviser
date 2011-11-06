# midi_in_port_spec.rb

require 'midi/in_port'

describe Midi::InPort do
  
  before(:each) do
    @port0_id = `aconnect -i | grep 'Virtual Raw MIDI 1-0' | awk '{print $2}' | sed -e 's/://'`.chop
    @port1_id = `aconnect -o | grep 'Virtual Raw MIDI 1-1' | awk '{print $2}' | sed -e 's/://'`.chop
    @cmd = "aconnect #{@port0_id}:0 #{@port1_id}:0"
    system(@cmd)
  end
  
  after(:each) do
    @inport.close if !@inport.nil?
    @inport = nil if !@inport.nil?
    @outport.close if !@outport.nil?
    @outport = nil if !@outport.nil?
  
    @port0_id = `aconnect -i | grep 'Virtual Raw MIDI 1-0' | awk '{print $2}' | sed -e 's/://'`.chop
    @port1_id = `aconnect -o | grep 'Virtual Raw MIDI 1-1' | awk '{print $2}' | sed -e 's/://'`.chop
    @cmd = "aconnect -d #{@port0_id}:0 #{@port1_id}:0"
    system(@cmd)
  end
  
  describe "#initialize" do
    it "throws an error if you specify an invalid midi port" do
      expect { @inport = Midi::InPort.new("Invalid MIDI port") }.to raise_error(ArgumentError)
    end
  end

  describe "#initialize" do
    it "succeeds if you specify a valid midi port" do
    #  @inport = Midi::InPort.new("Midi Through Port-0")
    #  @inport.nil?.should be_false
    end
  end

  describe "#start" do
    it "raises an error if you haven't specified a read event handler" do
      #true.should be_false
    end
  end

  describe "#start" do
    it "causes the callback to begin being called when events are received" do
      #true.should be_false
    end
  end

  describe "#stop" do
    it "raises an error if start hasn't been called" do
      #true.should be_false
    end
  end

  describe "#stop" do
    it "causes the callback to stop  being called when events are received" do
      #true.should be_false
    end
  end

end
