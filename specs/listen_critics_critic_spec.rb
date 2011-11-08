# listen_critic_spec.rb

require 'midi/event_queue'

# assumes a @critic has been defined :before this
shared_examples_for "a critic" do

  describe "#observe" do
    it "should return a hash containing :surprise" do
      @evq = Midi::EventQueue.new
      @num_events=(rand*50).round
      @num_events.times do 
        @evq.enqueue(Midi::Event.new({:message => Midi::Event::NOTE_ON, :pitch => 40, :velocity => 100, :timestamp => 1000}))
      end

      @critic.observe(@evq).keys.should == [:surprise]
    end
  end

  describe "#generate_next_event" do
    it "returns nil if no observations have been made" do
      @critic.generate_next_event([]).nil?.should be_true
    end
  end

  describe "#generate_next_event" do
    it "returns a hash containing keys :next_event and :surprise" do
      @evq = Midi::EventQueue.new
      @num_events=(rand*50).round
      @num_events.times do 
        @evq.enqueue(Midi::Event.new({:message => Midi::Event::NOTE_ON, :pitch => 40, :velocity => 100, :timestamp => 1000}))
      end
      @critic.observe(@evq)

      @critic.generate_next_event(Midi::EventQueue.new).keys.sort.should == [:next_state, :surprise]
    end
  end

  describe "#evaluate_next_event" do
    it "returns nil if no observations have been made" do
      @critic.evaluate_next_event(
                      Midi::EventQueue.new, 
                      Midi::Event.new({:message => Midi::Event::NOTE_ON, 
                                       :pitch => 40, 
                                       :velocity => 100, 
                                       :timestamp => 1000}) ).nil?.should be_true
    end
  end

  describe "#evaluate_next_event" do
    it "returns a next " do
      @evq = Midi::EventQueue.new
      @num_events=(rand*50).round
      @num_events.times do 
        @evq.enqueue(Midi::Event.new({:message => Midi::Event::NOTE_ON, :pitch => 40, :velocity => 100, :timestamp => 1000}))
      end
      @critic.observe(@evq)

      @critic.evaluate_next_event(
                      Midi::EventQueue.new, 
                      Midi::Event.new({:message => Midi::Event::NOTE_ON, 
                                       :pitch => 40, 
                                       :velocity => 100, 
                                       :timestamp => 1000}) ).keys.should == [:surprise]
    end
  end

end

