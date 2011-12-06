#!/usr/bin/env ruby 

require 'random_variable'

describe RandomVariable do
  before do
  end

  context "new" do
    it "creates a blank random variable with a fixed number of outcomes" do
      num_outcomes = 5
      RandomVariable.new(num_outcomes).should be_an_instance_of RandomVariable
    end
    it "raises an error if the number of outcomes is less than 1" do
      num_outcomes = 0
      expect{ RandomVariable.new(num_outcomes) }.to raise_error(ArgumentError)
    end
  end

  context "transform_outcomes" do
    it "runs a transform on each outcome" do
      num_outcomes = 5
      x = RandomVariable.new(num_outcomes)
      outcome = 3
      num_observations = 10
      x.add_possible_outcome(outcome, num_observations)

      symbol_to_outcome = lambda { |y| y*10 }
      outcome_to_symbol = lambda { |y| y/10 }
      x.transform_outcomes(symbol_to_outcome, outcome_to_symbol)

      x.choose_outcome.should == 30
    end
    it "causes 'get_surprise' to reverse-transform the given outcome" do
      num_outcomes = 5
      x = RandomVariable.new(num_outcomes)
      outcome = 1
      num_observations = 1
      x.add_possible_outcome(outcome, num_observations)

      symbol_to_outcome = lambda { |y| y*10 }
      outcome_to_symbol = lambda { |y| y/10 }
      x.transform_outcomes(symbol_to_outcome, outcome_to_symbol)

      x.get_surprise(10).should be_within(0.01).of(0.0)
    end
  end

  context "+" do
    before (:each) do
      @num_outcomes = 5
      @x1 = RandomVariable.new(@num_outcomes)
      @outcome = 3
      @num_observations = 10
      @x1.add_possible_outcome(@outcome, @num_observations)

      @num_outcomes = 5
      @x2 = RandomVariable.new(@num_outcomes)
      @outcome = 4
      @num_observations = 1
      @x2.add_possible_outcome(@outcome, @num_observations)
    end
    it "combines the random variables, so that get_surprise still works" do
      @x1 = @x1 + @x2
      @x1.get_surprise(3).should be < @x1.get_surprise(4)
    end
    it "combines the random variables, so that get_surprise still works" do
      @x1 = @x1 + @x2
      @x1.get_surprise(4).should be < 1.0
    end
    it "combines the random variables, such that choose_outcome uses outcomes from both random variables" do
      @x1 = @x1 + @x2
      [3, 4].include?(@x1.choose_outcome).should be_true
    end
    it "combines the random variables, even if the first one is transformed" do
      symbol_to_outcome = lambda {|y| y+1}
      outcome_to_symbol = lambda {|y| y-1}
      @x1.transform_outcomes(symbol_to_outcome, outcome_to_symbol)
      @x1 = @x1 + @x2
      @x1.choose_outcome.should == 4
    end
    it "combines the random variables, even if the second one is transformed" do
      symbol_to_outcome = lambda {|y| y-1}
      outcome_to_symbol = lambda {|y| y+1}
      @x2.transform_outcomes(symbol_to_outcome, outcome_to_symbol)
      @x1 = @x1 + @x2
      @x1.choose_outcome.should == 3
    end
    it "combines the random variables, even the two have different numbers of outcomes and are transformed" do
      num_outcomes = 5
      x1 = RandomVariable.new(num_outcomes)
      outcome = 4
      num_observations = 10
      x1.add_possible_outcome(outcome, num_observations)
      symbol_to_outcome = lambda {|y| y+21}
      outcome_to_symbol = lambda {|y| y-21}
      x1.transform_outcomes(symbol_to_outcome, outcome_to_symbol)

      num_outcomes = 2
      x2 = RandomVariable.new(num_outcomes)
      outcome = 0
      num_observations = 1
      x2.add_possible_outcome(outcome, num_observations)
      symbol_to_outcome = lambda {|y| y-1}
      outcome_to_symbol = lambda {|y| y+1}
      x2.transform_outcomes(symbol_to_outcome, outcome_to_symbol)

      x1 = x1 + x2

      [25, -1].include?(x1.choose_outcome).should be_true
    end
  end

  context "add_possible_outcome" do
    it "increases the probability that the possible outcome will be chosen" do
      outcome = 3
      num_observations = 1
      num_outcomes = 5
      x = RandomVariable.new(num_outcomes)
      x.add_possible_outcome(outcome, num_observations)
      x.choose_outcome.should == 3
    end
    it "raises an error if the number of observations is negative" do
      outcome = 3
      num_observations = -1
      num_outcomes = 5
      x = RandomVariable.new(num_outcomes)
      expect{ x.add_possible_outcome(outcome, num_observations) }.to raise_error(ArgumentError)
    end
  end

  context "choose_outcome" do
    it "returns nil if no possibilities have been added" do
      num_outcomes = 5
      x = RandomVariable.new(num_outcomes)
      x.choose_outcome.should be_nil
    end
    it "returns one of the possible outcomes" do
      num_outcomes = 5
      x = RandomVariable.new(num_outcomes)
      outcome = 1
      num_observations = 1
      x.add_possible_outcome(outcome, num_observations)
      outcome = 2
      num_observations = 2
      x.add_possible_outcome(outcome, num_observations)
      [1, 2].include?(x.choose_outcome).should be true
    end
  end

  context "get_surprise" do
    it "returns 0.5 if no observations have been made" do
      num_outcomes = 5
      x = RandomVariable.new(num_outcomes)
      x.get_surprise(0).should be_within(0.01).of(0.5)
    end
    it "returns a value between 0.0 and 1.0" do
      num_outcomes = 5
      x = RandomVariable.new(num_outcomes)
      outcome = 1
      num_observations = 1
      x.add_possible_outcome(outcome, num_observations)
      outcome = 2
      num_observations = 2
      x.add_possible_outcome(outcome, num_observations)
      x.get_surprise(0).should be_between(0.0, 1.0)
    end
    it "returns 1.0 for outcomes that have never been observed" do
      num_outcomes = 5
      x = RandomVariable.new(num_outcomes)
      outcome = 1
      num_observations = 1
      x.add_possible_outcome(outcome, num_observations)
      outcome = 2
      num_observations = 2
      x.add_possible_outcome(outcome, num_observations)
      x.get_surprise(0).should be_within(0.01).of(1.0)
    end
    it "returns 0.0 for an outcome that is the only one observed" do
      num_outcomes = 5
      x = RandomVariable.new(num_outcomes)
      outcome = 1
      num_observations = 1
      x.add_possible_outcome(outcome, num_observations)
      x.get_surprise(1).should be_within(0.01).of(0.0)
    end
    it "returns higher values (more surprise) for outcomes that have been observed less" do
      num_outcomes = 5
      x = RandomVariable.new(num_outcomes)
      outcome = 1
      num_observations = 1
      x.add_possible_outcome(outcome, num_observations)
      outcome = 2
      num_observations = 2
      x.add_possible_outcome(outcome, num_observations)
      x.get_surprise(1).should be > x.get_surprise(2)
    end
  end

end
