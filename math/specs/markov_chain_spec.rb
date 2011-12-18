#!/usr/bin/env ruby

require "spec_helper"

describe Math::MarkovChain do
  before do
  end

  context "new" do
    it "builds a chain with an order (# of current/past states used to predict the future) of 1 or greater" do
      Math::MarkovChain.new(order=1, num_states=5).should be_an_instance_of Math::MarkovChain
    end
    it "raises an error for an order of 0 or lower" do
      expect{ Math::MarkovChain.new(order=0, num_states=5) }.to raise_error(ArgumentError)
    end
    it "builds a chain with two or more states" do
      Math::MarkovChain.new(order=1, num_states=2).should be_an_instance_of Math::MarkovChain
    end
    it "raises an error for fewer than 2 states" do
      expect{ Math::MarkovChain.new(order=1, num_states=1) }.to raise_error(ArgumentError)
    end
  end

  context "current_state" do
    it "returns nil if in the initial state" do
      mc = Math::MarkovChain.new(order=1, num_states=2)
      mc.current_state.should equal nil
    end
    it "returns the current state" do
      mc = Math::MarkovChain.new(order=1, num_states=2)
      mc.transition(0)
      mc.current_state.should equal 0
    end
  end

  context "order" do
    it "returns the number of historical states the chain uses to predict future states" do
      mc = Math::MarkovChain.new(order=1, num_states=3)
      mc.order.should == 1
    end
  end

  context "reset" do
    it "resets the state back to the initial state (undoes do_transitions)" do
      mc = Math::MarkovChain.new(order=1, num_states=2)
      mc.transition(0)
      mc.reset
      mc.current_state.should be_nil
    end
  end

  context "save" do
    it "saves the markov chain to a file" do
      mc = Math::MarkovChain.new(order=1, num_states=2)
      mc.observe(1)
      mc.observe(1)
      mc.observe(0)
      filename = "/tmp/rubymidi_markov_chain.yml"
      mc.save filename
      File.exists?(filename).should == true
    end
  end

  context "load" do
    it "loads the markov chain to a file" do
      mc = Math::MarkovChain.new(order=1, num_states=20)
      mc.observe(1)
      mc.transition(1)
      mc.observe(2)
      mc.transition(2)
      mc.observe(3)
      mc.transition(3)
      mc.reset
      mc.transition(2)
      filename = "/tmp/rubymidi_markov_chain.yml"
      mc.save filename
      mc2 = Math::MarkovChain.load filename
      x = mc2.get_expectations
      x.choose_outcome.should == 3
    end
  end

  context "observe" do
    it "raises an error if the state is outside the 0..(num_states-1) range" do
      mc = Math::MarkovChain.new(order=1, num_states=2)
      expect{ mc.observe(num_states) }.to raise_error(ArgumentError)
    end
    it "adds an observation of the next symbol" do
      mc = Math::MarkovChain.new(order=1, num_states=2)
      mc.observe(0)
      mc.current_state.should equal nil
    end
    it "does not update state" do
      mc = Math::MarkovChain.new(order=1, num_states=2)
      mc.transition(1)
      mc.observe(0)
      mc.current_state.should equal 1
    end
  end

  context "transition" do
    it "raises an error if the state is outside the 0..(num_states-1) range" do
      mc = Math::MarkovChain.new(order=1, num_states=2)
      expect{ mc.transition(num_states) }.to raise_error(ArgumentError)
    end
    it "does not add an observation of the next symbol" do
      mc = Math::MarkovChain.new(order=1, num_states=2)
      mc.transition(1)
      mc.reset
      mc.get_expectations.choose_outcome.should be_nil
    end
    it "changes the state" do
      mc = Math::MarkovChain.new(order=1, num_states=2)
      mc.transition(1)
      mc.current_state.should equal 1
    end
  end

  context "get_expectations" do
    it "returns a random variable" do
      mc = Math::MarkovChain.new(order=1, num_states=2)
      mc.get_expectations.should be_an_instance_of Math::RandomVariable
    end
    it "returns a random variable that is less surprised about states observed more often" do
      mc = Math::MarkovChain.new(order=1, num_states=2)
      mc.observe(1)
      mc.observe(1)
      mc.observe(0)
      x = mc.get_expectations
      x.get_surprise(1).should be < x.get_surprise(0)
    end
    it "returns a random variable that only chooses states observed" do
      mc = Math::MarkovChain.new(order=1, num_states=2)
      mc.observe(1)
      x = mc.get_expectations
      x.choose_outcome.should equal 1
    end
    it "returns a random variable that only chooses states observed (higher order)" do
      mc = Math::MarkovChain.new(order=2, num_states=5)
      mc.observe(1)
      mc.transition(1)
      mc.observe(2)
      mc.transition(2)
      mc.observe(4)
      mc.transition(4)
      mc.reset
      mc.observe(0)
      mc.transition(0)
      mc.observe(2)
      mc.transition(2)
      mc.observe(3)
      mc.transition(3)
      mc.reset
      mc.transition(0)
      mc.transition(2)
      x = mc.get_expectations
      x.choose_outcome.should equal 3
    end
    it "isn't surprised by repeated substrings in a long string" do
      mc = Math::MarkovChain.new(order=2, num_states=100)
      pitches = [64, 71, 71, 69, 76, 74, 73, 71, 74, 73, 71, 73, 74, 73, 71, 73, 71] #, 73
      pitches.each do |pitch|
        mc.observe(pitch)
      end
      x = mc.get_expectations
      x.get_surprise(73).should be < 0.5
    end
  end

end
