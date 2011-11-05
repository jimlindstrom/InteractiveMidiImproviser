# midi_device_layer_spec.rb

require 'midi/device_layer'

describe Midi::DeviceLayer do

  before(:each) do
  end

  after(:each) do
    @devlayer = nil
  end
     
  describe "#initialize" do
    it "throws an error if midi input device is invalid" do
      expect { @devlayer = Midi::DeviceLayer.new(100,100) }.to raise_error(ArgumentError)
    end
  end
    
  describe "#initialize" do
    it "throws an error if midi output device is invalid" do
      expect { @devlayer = Midi::DeviceLayer.new(1,100) }.to raise_error(ArgumentError)
    end
  end

  describe "#stop" do
    it "throws an error if not running" do
      #@devlayer = Midi::DeviceLayer.new(6,7)
      #expect { @devlayer.stop }.to raise_error(ThreadError)
    end
  end

  describe "#start" do
    it "throws an error if not running" do
      #@devlayer = Midi::DeviceLayer.new(6,7)
      #@devlayer.start
      #expect { @devlayer.start }.to raise_error(ThreadError)
      #@devlayer.stop
    end
  end

end
