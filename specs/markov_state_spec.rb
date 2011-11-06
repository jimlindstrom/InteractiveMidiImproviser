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

    it "returns a state according to the added observations" do
      @state = Markov::State.new(3)
      @state.add_observation(0)
      @state.generate.should == { :next_state => 0, :surprise => 0.0 }
    end

    it "doesn't return state that it hasn't observed" do
      @state = Markov::State.new(3)
      @state.add_observation(0)
      @state.add_observation(1)
      @state.generate[:next_state].should_not == 2
    end

    it "doesn't return state that it hasn't observed" do
      @state = Markov::State.new(128)
      @state.add_observation(60)
      @state.add_observation(60)
      @state.generate.should == { :next_state => 60, :surprise => 0.0 }
    end
  end

  describe "#possible_next_states" do
    it "returns a hash containing :total_observations and :possible_next_states" do
      @state = Markov::State.new(3)
      @state.add_observation(0)
      @state.add_observation(1)
      @state.possible_next_states.keys.sort.should == [ :possible_next_states, :total_observations ]
    end

    it "return only states that have been observed as next steps" do
      @state = Markov::State.new(3)
      @state.add_observation(1)
      @state.add_observation(1)
      @state.possible_next_states[:possible_next_states].should == [{ :next_state => 1, :num_observations => 2 }]
    end
  end

end
