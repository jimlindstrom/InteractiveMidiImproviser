# midi_clock_spec.rb

describe Midi::Clock do

  before(:each) do
  end
    
  describe "#is_ready?" do
    it "returns false if timestamp hasn't been set" do
      @clock = Midi::Clock.new(0)
      @clock.is_ready?.should == false
    end
  end

  describe "#is_ready?" do
    it "returns true if timestamp has been set" do
      @clock = Midi::Clock.new(0)
      @clock.set_timestamp(0)
      @clock.is_ready?.should == true
    end
  end

  describe "#get_timestamp" do
    it "returns nil if timestamp has never been set" do
      @clock = Midi::Clock.new(0)
      @clock.get_timestamp.should == nil
    end
  end

  describe "#get_timestamp" do
    it "returns the midi time in msec, if timestamp has been set" do
      @clock = Midi::Clock.new(0)
      @clock.set_timestamp(0)
      sleep 0.05
      @clock.get_timestamp.should be_within(5).of(50)
    end
  end

  describe "#initialize" do
    it "sets the latency, which future-dates timestamps" do
      @clock = Midi::Clock.new(500)
      @clock.set_timestamp(0)
      sleep 0.02
      @clock.get_timestamp.should be_within(5).of(520)
    end
  end

end
