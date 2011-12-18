#!/usr/bin/env ruby

require "spec_helper"

describe Math::BidirectionalMarkovChain do
  before do
  end

  context "new" do
    it "builds a chain with an order (# of current/past states used to predict the future) of 1 or greater" do
      Math::BidirectionalMarkovChain.new(order=1, lookahead=3, num_states=5).should be_an_instance_of Math::BidirectionalMarkovChain
    end
    it "raises an error for an order of 0 or lower" do
      expect{ Math::BidirectionalMarkovChain.new(order=0, lookahead=2, num_states=5) }.to raise_error(ArgumentError)
    end
    it "builds a chain with two or more states" do
      Math::BidirectionalMarkovChain.new(order=1, lookahead=2, num_states=2).should be_an_instance_of Math::BidirectionalMarkovChain
    end
    it "raises an error for fewer than 2 states" do
      expect{ Math::BidirectionalMarkovChain.new(order=1, lookahead=1, num_states=1) }.to raise_error(ArgumentError)
    end
    it "raises an error if not looking ahead 1 or more steps" do
      expect{ Math::BidirectionalMarkovChain.new(order=1, lookahead=0, num_states=2) }.to raise_error(ArgumentError)
    end
  end

  context "current_state" do
    it "returns nil if in the initial state" do
      mc = Math::BidirectionalMarkovChain.new(order=1, lookahead=1, num_states=2)
      mc.current_state.should equal nil
    end
    it "returns the current state" do
      mc = Math::BidirectionalMarkovChain.new(order=1, lookahead=1, num_states=2)
      mc.transition(state=0, steps_left=1)
      mc.current_state.should equal 0
    end
  end

  context "steps_left" do
    it "returns nil if unknown" do
      mc = Math::BidirectionalMarkovChain.new(order=1, lookahead=1, num_states=2)
      mc.steps_left.should be_nil
    end
    it "returns nil if more steps are left than the lookahead" do
      mc = Math::BidirectionalMarkovChain.new(order=1, lookahead=2, num_states=2)
      mc.transition(state=1, steps_left=4)
      mc.steps_left.should be_nil
    end
    it "returns the number of steps left if 0..(lookahead-1) steps left" do
      mc = Math::BidirectionalMarkovChain.new(order=1, lookahead=4, num_states=2)
      mc.transition(state=1, steps_left=1)
      mc.steps_left.should equal 1
    end
  end

  context "order" do
    it "returns the number of historical states the chain uses to predict future states" do
      mc = Math::BidirectionalMarkovChain.new(order=1, lookahead=2, num_states=3)
      mc.order.should == 1
    end
  end

  context "lookahead" do
    it "returns the number of steps the chain will look ahead to plan for the terminal state" do
      mc = Math::BidirectionalMarkovChain.new(order=1, lookahead=2, num_states=3)
      mc.lookahead.should == 2
    end
  end

  context "reset" do
    it "resets the state back to the initial state (undoes do_transitions)" do
      mc = Math::BidirectionalMarkovChain.new(order=1, lookahead=1, num_states=2)
      mc.transition(state=0, steps_left=0)
      mc.reset
      mc.current_state.should be_nil
      mc.steps_left.should be_nil
    end
  end

  context "save" do
    it "saves the markov chain to a file" do
      mc = Math::BidirectionalMarkovChain.new(order=1, lookahead=1, num_states=2)
      mc.observe(state=1, steps_left=2)
      mc.observe(state=1, steps_left=2)
      mc.observe(state=0, steps_left=2)
      filename = "/tmp/rubymidi_bidirectional_markov_chain.yml"
      mc.save filename
      File.exists?(filename).should == true
    end
  end

  context "load" do
    it "loads the markov chain to a file" do
      mc = Math::BidirectionalMarkovChain.new(order=1, lookahead=1, num_states=20)
      mc.observe(   state=1, steps_left=3)
      mc.transition(state=1, steps_left=3)
      mc.observe(   state=3, steps_left=2)
      mc.transition(state=3, steps_left=2)
      mc.observe(   state=1, steps_left=1)
      mc.transition(state=1, steps_left=1)
      mc.observe(   state=2, steps_left=0)
      mc.transition(state=2, steps_left=0)
      mc.reset
      mc.transition(state=1, steps_left=1)
      filename = "/tmp/rubymidi_bidirectional_markov_chain.yml"
      mc.save filename
      mc2 = Math::BidirectionalMarkovChain.load filename
      x = mc2.get_expectations
      x.choose_outcome.should == 2
    end
  end

  context "observe" do
    it "raises an error if the state is outside the 0..(num_states-1) range" do
      mc = Math::BidirectionalMarkovChain.new(order=1, lookahead=1, num_states=2)
      expect{ mc.observe(state=num_states, steps_left=2) }.to raise_error(ArgumentError)
    end
    it "raises an error if the number of steps left is less than zero" do
      mc = Math::BidirectionalMarkovChain.new(order=1, lookahead=1, num_states=2)
      expect{ mc.observe(state=1, steps_left=-1) }.to raise_error(ArgumentError)
    end
    it "raises an error if steps_left is !nil and the observed steps_left is not exactly one less" do
      mc = Math::BidirectionalMarkovChain.new(order=1, lookahead=5, num_states=2)
      mc.transition(state=1, steps_left=3)
      expect{ mc.observe(state=1, steps_left=1) }.to raise_error(ArgumentError)
    end
    it "adds an observation of the next symbol" do
      mc = Math::BidirectionalMarkovChain.new(order=1, lookahead=1, num_states=2)
      mc.observe(state=0, steps_left=1)
      pending
    end
    it "does not update state" do
      mc = Math::BidirectionalMarkovChain.new(order=1, lookahead=4, num_states=2)
      mc.transition(state=1, steps_left=1)
      mc.observe(state=0, steps_left=0)
      mc.current_state.should equal 1
    end
    it "does not update steps_left" do
      mc = Math::BidirectionalMarkovChain.new(order=1, lookahead=4, num_states=2)
      mc.transition(state=1, steps_left=1)
      mc.observe(state=0, steps_left=0)
      mc.steps_left.should equal 1
    end
  end

  context "transition" do
    it "raises an error if the state is outside the 0..(num_states-1) range" do
      mc = Math::BidirectionalMarkovChain.new(order=1, lookahead=1, num_states=2)
      expect{ mc.transition(state=num_states, steps_left=3) }.to raise_error(ArgumentError)
    end
    it "does not add an observation of the next symbol" do
      mc = Math::BidirectionalMarkovChain.new(order=1, lookahead=1, num_states=2)
      mc.transition(state=1, steps_left=3)
      mc.reset
      mc.get_expectations.choose_outcome.should be_nil
    end
    it "changes the state" do
      mc = Math::BidirectionalMarkovChain.new(order=1, lookahead=1, num_states=2)
      mc.transition(state=1, steps_left=3)
      mc.current_state.should equal 1
    end
    it "updates steps_left" do
      mc = Math::BidirectionalMarkovChain.new(order=1, lookahead=4, num_states=2)
      mc.transition(state=1, steps_left=2)
      mc.steps_left.should equal 2
    end
  end

  context "get_expectations" do
    it "returns a random variable" do
      mc = Math::BidirectionalMarkovChain.new(order=1, lookahead=1, num_states=2)
      mc.get_expectations.should be_an_instance_of Math::RandomVariable
    end
    it "returns a random variable that is less surprised about states observed more often" do
      mc = Math::BidirectionalMarkovChain.new(order=1, lookahead=1, num_states=2)
      mc.observe(state=1, steps_left=8)
      mc.observe(state=1, steps_left=8)
      mc.observe(state=0, steps_left=8)
      x = mc.get_expectations
      x.get_surprise(state=1).should be < x.get_surprise(state=0)
    end
    it "returns a random variable that only chooses states observed" do
      mc = Math::BidirectionalMarkovChain.new(order=1, lookahead=1, num_states=2)
      mc.observe(state=1, steps_left=8)
      x = mc.get_expectations
      x.choose_outcome.should equal 1
    end
    it "returns a random variable that only chooses states observed (higher order)" do
      mc = Math::BidirectionalMarkovChain.new(order=2, lookahead=1, num_states=5)
      mc.observe(   state=1, steps_left=5)
      mc.transition(state=1, steps_left=5)
      mc.observe(   state=2, steps_left=4)
      mc.transition(state=2, steps_left=4)
      mc.observe(   state=4, steps_left=3)
      mc.transition(state=4, steps_left=3)
      mc.reset
      mc.observe(   state=0, steps_left=5)
      mc.transition(state=0, steps_left=5)
      mc.observe(   state=2, steps_left=4)
      mc.transition(state=2, steps_left=4)
      mc.observe(   state=3, steps_left=3)
      mc.transition(state=3, steps_left=3)
      mc.reset
      mc.transition(state=0, steps_left=5)
      mc.transition(state=2, steps_left=4)
      x = mc.get_expectations
      x.choose_outcome.should equal 3
    end
    it "returns a random variable that only chooses states observed with the same steps remaining" do
      mc = Math::BidirectionalMarkovChain.new(order=1, lookahead=1, num_states=5)
      mc.observe(   state=1, steps_left=3)
      mc.transition(state=1, steps_left=3)
      mc.observe(   state=3, steps_left=2)
      mc.transition(state=3, steps_left=2)
      mc.observe(   state=1, steps_left=1)
      mc.transition(state=1, steps_left=1)
      mc.observe(   state=2, steps_left=0)
      mc.transition(state=2, steps_left=0)
      mc.reset
      mc.transition(state=1, steps_left=1)
      x = mc.get_expectations
      x.choose_outcome.should equal 2
    end
  end

end
