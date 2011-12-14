#!/usr/bin/env ruby

require "spec_helper"

# I'd love to have a version of this that works for future states instead of history 
# states.  E.g., if you know that the phrase is ending in 2 notes, you should be able to say,
# I'm in state <X>, I'm looking for state <Y>, and then there's going to be some state <Z> that
# is terminal.  Given that, what are your expectations about state Y?

# FIXME: Need to add a bunch more tests to show tha the higher-order versions work, too

describe MarkovChain do
  before do
  end

  context "new" do
    it "builds a chain with an order (# of current/past states used to predict the future) of 1 or greater" do
      order      = 1
      num_states = 5
      MarkovChain.new(order, num_states).should be_an_instance_of MarkovChain
    end
    it "raises an error for an order of 0 or lower" do
      order      = 0
      num_states = 5
      expect{ MarkovChain.new(order, num_states) }.to raise_error(ArgumentError)
    end
    it "builds a chain with two or more states" do
      order      = 1
      num_states = 2
      MarkovChain.new(order, num_states).should be_an_instance_of MarkovChain
    end
    it "raises an error for fewer than 2 states" do
      order      = 1
      num_states = 1
      expect{ MarkovChain.new(order, num_states) }.to raise_error(ArgumentError)
    end
  end

  context "current_state" do
    it "returns nil if in the initial state" do
      order      = 1
      num_states = 2
      mc = MarkovChain.new(order, num_states)
      mc.current_state.should equal nil
    end
    it "returns the current state" do
      order      = 1
      num_states = 2
      mc = MarkovChain.new(order, num_states)
      mc.transition(0)
      mc.current_state.should equal 0
    end
  end

  context "reset" do
    it "resets the state back to the initial state (undoes do_transitions)" do
      order      = 1
      num_states = 2
      mc = MarkovChain.new(order, num_states)
      mc.transition(0)
      mc.reset
      mc.current_state.should be_nil
    end
  end

  context "observe" do
    it "raises an error if the state is outside the 0..(num_states-1) range" do
      order      = 1
      num_states = 2
      mc = MarkovChain.new(order, num_states)
      expect{ mc.observe(num_states) }.to raise_error(ArgumentError)
    end
    it "adds an observation of the next symbol" do
      order      = 1
      num_states = 2
      mc = MarkovChain.new(order, num_states)
      mc.observe(0)
      mc.current_state.should equal nil
    end
    it "does not update state" do
      order      = 1
      num_states = 2
      mc = MarkovChain.new(order, num_states)
      mc.transition(1)
      mc.observe(0)
      mc.current_state.should equal 1
    end
  end

  context "transition" do
    it "raises an error if the state is outside the 0..(num_states-1) range" do
      order      = 1
      num_states = 2
      mc = MarkovChain.new(order, num_states)
      expect{ mc.transition(num_states) }.to raise_error(ArgumentError)
    end
    it "does not add an observation of the next symbol" do
      order      = 1
      num_states = 2
      mc = MarkovChain.new(order, num_states)
      mc.transition(1)
      mc.reset
      mc.get_expectations.choose_outcome.should be_nil
    end
    it "changes the state" do
      order      = 1
      num_states = 2
      mc = MarkovChain.new(order, num_states)
      mc.transition(1)
      mc.current_state.should equal 1
    end
  end

  context "get_expectations" do
    it "returns a random variable" do
      order      = 1
      num_states = 2
      mc = MarkovChain.new(order, num_states)
      mc.get_expectations.should be_an_instance_of RandomVariable
    end
    it "returns a random variable that is less surprised about states observed more often" do
      order      = 1
      num_states = 2
      mc = MarkovChain.new(order, num_states)
      mc.observe(1)
      mc.observe(1)
      mc.observe(0)
      x = mc.get_expectations
      x.get_surprise(1).should be < x.get_surprise(0)
    end
    it "returns a random variable that only chooses states observed" do
      order      = 1
      num_states = 2
      mc = MarkovChain.new(order, num_states)
      mc.observe(1)
      x = mc.get_expectations
      x.choose_outcome.should equal 1
    end
    it "returns a random variable that only chooses states observed (higher order)" do
      order      = 2
      num_states = 5
      mc = MarkovChain.new(order, num_states)
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
  end

end
