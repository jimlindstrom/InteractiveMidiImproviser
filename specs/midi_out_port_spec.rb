# midi_out_port_spec.rb

require 'thread'
require 'midi/clock'
require 'midi/out_port'
require 'midi/in_port'
require 'midi/event'

describe Midi::OutPort do

  before(:each) do
    system("/home/lindstro/code/rubymidi/util/virtual_midi_loopback.rb &")
  end

  after(:each) do
    @inport.close if !@inport.nil?
    @inport = nil if !@inport.nil?
    @outport.close if !@outport.nil?
    @outport = nil if !@outport.nil?

    @pid=`ps aux | grep 'util/virtual' | grep -v grep | awk '{print $2}'`
    if @pid.to_i > 1 and @pid.to_i < 65565
      system("kill -9 #{@pid.to_i}")
    end
  end

  describe "#initialize" do
    it "throws an error if you specify an invalid midi port" do
      expect { @outport = Midi::OutPort.new("Invalid MIDI port") }.to raise_error(ArgumentError)
    end

    it "succeeds if you specify a valid midi port" do
      @outport = Midi::OutPort.new("VirMIDI 1-0")
      @outport.class.should == Midi::OutPort
    end
  end

  describe "#write" do
    it "writes a single event into the port" do
      Thread.abort_on_exception = true
      @clock = Midi::Clock.new(0)
      @inport = Midi::InPort.new("VirMIDI 1-1", @clock)
      @outport = Midi::OutPort.new("VirMIDI 1-0")
      @reading=false
      @thread_id = Thread.new do
        while !@reading do 
          sleep 0.1 
        end
        sleep 0.05
        @event = Midi::Event.new({:message=>Midi::Event::NOTE_ON,  :pitch=>100, :velocity=>100, :timestamp=>0})
        @outport.write(@event)
        sleep 0.05
        @event = Midi::Event.new({:message=>Midi::Event::NOTE_OFF, :pitch=>100, :velocity=>100, :timestamp=>0})
        @outport.write(@event)
      end
      @reading=true
      @evt = @inport.blocking_read
      @evt.class.should == Midi::Event
      @thread_id.join
    end
  end

end
