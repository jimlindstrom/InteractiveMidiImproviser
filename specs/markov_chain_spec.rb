# markov_chain_spec.rb

require 'markov/chain'

describe Markov::Chain do

  before(:each) do
  end

  describe "#generate_next" do
    it "returns nil if no prior observations" do
      @chain = Markov::Chain.new(128)
      @chain.generate_next([]).should == nil
    end
  end

  describe "#generate_next" do
    it "returns a statistically likely first state, if no history given" do
      @chain = Markov::Chain.new(128)
      @chain.add_observation([60,64,67])
      @chain.generate_next([]).should == { :next_state => 60, :surprise => 0.0 }
    end
  end

  describe "#generate_next" do
    it "returns nil if history leads to unobserved state" do
      @chain = Markov::Chain.new(128)
      @chain.add_observation([60,64,67])
      @chain.generate_next([50]).should == nil
    end
  end

  describe "#generate_next" do
    it "returns a statistically likely next state, if history given" do
      @chain = Markov::Chain.new(128)
      @chain.add_observation([60,64,67])
      @chain.generate_next([60,64]).should == { :next_state => 67, :surprise => 0.0 }
    end
  end

  describe "#evaluate_next" do
    it "returns the surprise associated with the next state" do
      @chain = Markov::Chain.new(128)
      @chain.add_observation([60,64,67])
      @chain.evaluate_next([], 61).should == { :surprise => 0.5 }
    end
  end

end
