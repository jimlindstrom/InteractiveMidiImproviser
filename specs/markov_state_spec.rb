# markov_state_spec.rb

require 'markov/state'

describe Markov::State do

  before(:each) do
  end
   
  describe "#generate" do
    it "returns nil if no observations" do
      @state = Markov::State.new(3)
      @state.generate.should == nil
    end
  end

  describe "#generate" do
    it "returns a state according to the added observations" do
      @state = Markov::State.new(3)
      @state.add_observation(0)
      @state.generate.should == { :next_state => 0, :surprise => 0.0 }
    end
  end

  describe "#generate" do
    it "doesn't return state that it hasn't observed" do
      @state = Markov::State.new(3)
      @state.add_observation(0)
      @state.add_observation(1)
      @state.generate[:next_state].should_not == 2
    end
  end

  describe "#generate" do
    it "doesn't return state that it hasn't observed" do
      @state = Markov::State.new(128)
      @state.add_observation(60)
      @state.add_observation(60)
      @state.generate.should == { :next_state => 60, :surprise => 0.0 }
    end
  end
end
