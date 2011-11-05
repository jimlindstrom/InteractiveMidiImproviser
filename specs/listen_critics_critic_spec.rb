# listen_critic_spec.rb

require 'midi/event_queue'

# assumes a @critic has been defined :before this
shared_examples_for "a critic" do

  describe "#make_observation" do
    it "should return a hash containing :surprise" do
      @evq = Midi::EventQueue.new
      @num_events=(rand*50).round
      @num_events.times do 
        @evq.enqueue({:message=>[144,40,100,0],:timestamp=>1000})
      end

      @critic.make_observation(@evq).keys.should == [:surprise]
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
        @evq.enqueue({:message=>[144,40,100,0],:timestamp=>1000})
      end
      @critic.make_observation(@evq)

      @critic.generate_next_event(Midi::EventQueue.new).keys.should == [:surprise, :next_state]
    end
  end

  describe "#evaluate_next_event" do
    it "returns nil if no observations have been made" do
      @critic.evaluate_next_event(Midi::EventQueue.new, {:message=>[144,40,100,0],:timestamp=>1000}).nil?.should be_true
    end
  end

  describe "#evaluate_next_event" do
    it "returns a next " do
      @evq = Midi::EventQueue.new
      @num_events=(rand*50).round
      @num_events.times do 
        @evq.enqueue({:message=>[144,40,100,0],:timestamp=>1000})
      end
      @critic.make_observation(@evq)

      @critic.evaluate_next_event(Midi::EventQueue.new, {:message=>[144,40,100,0],:timestamp=>1000}).keys.should == [:surprise]
    end
  end

end

