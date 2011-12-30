#!/usr/bin/env ruby 

require 'random_variable'

describe Math::RandomVariable do
  before do
  end

  context "new" do
    it "creates a blank random variable with a fixed number of outcomes" do
      Math::RandomVariable.new(num_outcomes=5).should be_an_instance_of Math::RandomVariable
    end
    it "raises an error if the number of outcomes is less than 1" do
      expect{ Math::RandomVariable.new(num_outcomes=0) }.to raise_error(ArgumentError)
    end
  end

  context "transform_outcomes" do
    it "runs a transform on each outcome" do
      x = Math::RandomVariable.new(num_outcomes=5)
      x.add_possible_outcome(outcome=3, num_observations=10)

      symbol_to_outcome = lambda { |y| y*10 }
      outcome_to_symbol = lambda { |y| y/10 }
      x.transform_outcomes(symbol_to_outcome, outcome_to_symbol)

      x.choose_outcome.should == 30
    end
    it "causes 'get_surprise' to reverse-transform the given outcome" do
      x = Math::RandomVariable.new(num_outcomes=5)
      x.add_possible_outcome(outcome=1, num_observations=1)

      symbol_to_outcome = lambda { |y| y*10 }
      outcome_to_symbol = lambda { |y| y/10 }
      x.transform_outcomes(symbol_to_outcome, outcome_to_symbol)

      x.get_surprise(10).should be_within(0.01).of(0.0)
    end
  end

  context "+" do
    before (:each) do
      @x1 = Math::RandomVariable.new(@num_outcomes=5)
      @x1.add_possible_outcome(@outcome=3, @num_observations=10)

      @x2 = Math::RandomVariable.new(@num_outcomes=5)
      @x2.add_possible_outcome(@outcome=4, @num_observations=1)
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
      x1 = Math::RandomVariable.new(num_outcomes=5)
      x1.add_possible_outcome(outcome=4, num_observations=10)
      symbol_to_outcome = lambda {|y| y+21}
      outcome_to_symbol = lambda {|y| y-21}
      x1.transform_outcomes(symbol_to_outcome, outcome_to_symbol)

      x2 = Math::RandomVariable.new(num_outcomes=2)
      x2.add_possible_outcome(outcome=0, num_observations=1)
      symbol_to_outcome = lambda {|y| y-1}
      outcome_to_symbol = lambda {|y| y+1}
      x2.transform_outcomes(symbol_to_outcome, outcome_to_symbol)

      x1 = x1 + x2

      a = x1.choose_outcome
      [25, -1].include?(a).should be_true
    end
  end

  context "*" do
    before (:each) do
      @x1 = Math::RandomVariable.new(@num_outcomes=6)
      @x1.add_possible_outcome(@outcome=2, @num_observations=5)
      @x1.add_possible_outcome(@outcome=3, @num_observations=10)
      @x1.add_possible_outcome(@outcome=4, @num_observations=5)

      @x2 = Math::RandomVariable.new(@num_outcomes=6)
      @x2.add_possible_outcome(@outcome=3, @num_observations=4)
      @x2.add_possible_outcome(@outcome=4, @num_observations=12)
      @x2.add_possible_outcome(@outcome=5, @num_observations=4)
    end
    it "combines the random variables, so that get_surprise still works" do
      @x1 = @x1 * @x2
      @x1.get_surprise(3).should be < @x1.get_surprise(2)
    end
    it "combines the random variables, so that get_surprise still works" do
      @x1 = @x1 * @x2
      @x1.get_surprise(4).should be < 1.0
    end
    it "combines the random variables, such that choose_outcome uses outcomes from both random variables" do
      @x1 = @x1 * @x2
      [3, 4].include?(@x1.choose_outcome).should be_true
    end
    it "combines the random variables, even if the first one is transformed" do
      symbol_to_outcome = lambda {|y| y-1}
      outcome_to_symbol = lambda {|y| y+1}
      @x1.transform_outcomes(symbol_to_outcome, outcome_to_symbol)
      @x1 = @x1 * @x2
      @x1.choose_outcome.should == 3
    end
    it "combines the random variables, even if the second one is transformed" do
      symbol_to_outcome = lambda {|y| y+1}
      outcome_to_symbol = lambda {|y| y-1}
      @x2.transform_outcomes(symbol_to_outcome, outcome_to_symbol)
      @x1 = @x1 * @x2
      @x1.choose_outcome.should == 4
    end
    it "combines the random variables, even the two have different numbers of outcomes and are transformed" do
      x1 = Math::RandomVariable.new(num_outcomes=50)
      x1.add_possible_outcome(outcome=4, num_observations=10)
      symbol_to_outcome = lambda {|y| y+21}
      outcome_to_symbol = lambda {|y| y-21}
      x1.transform_outcomes(symbol_to_outcome, outcome_to_symbol)

      x2 = Math::RandomVariable.new(num_outcomes=50)
      x2.add_possible_outcome(outcome=26, num_observations=1)
      symbol_to_outcome = lambda {|y| y-1}
      outcome_to_symbol = lambda {|y| y+1}
      x2.transform_outcomes(symbol_to_outcome, outcome_to_symbol)

      x1 = x1 + x2

      a = x1.choose_outcome
      [25].include?(a).should be_true
    end
  end

  context "add_possible_outcome" do
    it "increases the probability that the possible outcome will be chosen" do
      x = Math::RandomVariable.new(num_outcomes=3)
      x.add_possible_outcome(outcome=2, num_observations=5)
      x.choose_outcome.should == 2
    end
    it "raises an error if the number of observations is negative" do
      x = Math::RandomVariable.new(num_outcomes=3)
      expect{ x.add_possible_outcome(outcome=-1, num_observations=5) }.to raise_error(ArgumentError)
    end
    it "increases the number of observations" do
      x = Math::RandomVariable.new(num_outcomes=3)
      x.add_possible_outcome(outcome=2, num_observations=5)
      x.num_observations.should == 5
    end
  end

  context "num_observations" do
    it "returns 0 for a new random variable" do
      x = Math::RandomVariable.new(num_outcomes=3)
      x.num_observations.should == 0
    end
    it "returns the sum of the number of observations made so far" do
      x = Math::RandomVariable.new(num_outcomes=3)
      x.add_possible_outcome(outcome=2, num_observations=1)
      x.add_possible_outcome(outcome=2, num_observations=2)
      x.add_possible_outcome(outcome=2, num_observations=3)
      x.num_observations.should == (1+2+3)
    end
  end

  context "choose_outcome" do
    it "returns nil if no possibilities have been added" do
      x = Math::RandomVariable.new(num_outcomes=5)
      x.choose_outcome.should be_nil
    end
    it "returns one of the possible outcomes" do
      x = Math::RandomVariable.new(num_outcomes=5)
      x.add_possible_outcome(outcome=1, num_observations=1)
      x.add_possible_outcome(outcome=2, num_observations=2)
      [1, 2].include?(x.choose_outcome).should be true
    end
  end

  context "probability" do
    it "returns the probability of an outcome" do
      x = Math::RandomVariable.new(num_outcomes=5)
      x.add_possible_outcome(outcome=1, num_observations=1)
      x.add_possible_outcome(outcome=2, num_observations=2)
      x.probability(1).should be_within(0.01).of(1.0/3.0)
    end
    it "raises an error if nothing has been observed" do
      x = Math::RandomVariable.new(num_outcomes=5)
      expect { x.probability(0) }.to raise_error
    end
  end

  context "scale" do
    it "increases the number of observations of all outcomes by a scaling factor" do
      x = Math::RandomVariable.new(num_outcomes=5)
      x.add_possible_outcome(outcome=1, num_observations=1)
      x.scale(2.0)
      x.add_possible_outcome(outcome=2, num_observations=2)
      x.probability(1).should be_within(0.0001).of(x.probability(2))
    end
  end

  context "get_surprise" do
    it "returns 0.5 if no observations have been made" do
      x = Math::RandomVariable.new(num_outcomes=5)
      x.get_surprise(0).should be_within(0.01).of(0.5)
    end
    it "returns a value between 0.0 and 1.0" do
      x = Math::RandomVariable.new(num_outcomes=5)
      x.add_possible_outcome(outcome=1, num_observations=1)
      x.add_possible_outcome(outcome=2, num_observations=2)
      x.get_surprise(0).should be_between(0.0, 1.0)
    end
    it "returns 1.0 for outcomes that have never been observed" do
      x = Math::RandomVariable.new(num_outcomes=5)
      x.add_possible_outcome(outcome=1, num_observations=1)
      x.add_possible_outcome(outcome=2, num_observations=2)
      x.get_surprise(0).should be_within(0.01).of(1.0)
    end
    it "returns 0.0 for an outcome that is the only one observed" do
      x = Math::RandomVariable.new(num_outcomes=5)
      x.add_possible_outcome(outcome=1, num_observations=1)
      x.get_surprise(1).should be_within(0.01).of(0.0)
    end
    it "returns higher values (more surprise) for outcomes that have been observed less" do
      x = Math::RandomVariable.new(num_outcomes=5)
      x.add_possible_outcome(outcome=1, num_observations=1)
      x.add_possible_outcome(outcome=2, num_observations=2)
      x.get_surprise(1).should be > x.get_surprise(2)
    end
  end

  context "entropy" do
    it "raises an error if no outcomes have been observed" do
      x = Math::RandomVariable.new(num_outcomes=5)
      expect{ x.entropy }.to raise_error(RuntimeError)
    end
    it "returns a value, H, that represents the uncertainty of the random variable" do
      x = Math::RandomVariable.new(num_outcomes=5)
      x.add_possible_outcome(outcome=0, num_observations=1)
      x.add_possible_outcome(outcome=1, num_observations=3)
      expected_H = 0.0
      expected_H -= 0.25 * Math.log2(0.25)
      expected_H -= 0.75 * Math.log2(0.75)
      x.entropy.should be_within(0.01).of(expected_H)
    end
  end

  context "max_entropy" do
    it "returns a value, H_max, that represents the maximum uncertainty for the number of outcomes" do
      x = Math::RandomVariable.new(num_outcomes=5)
      expected_H_max = Math.log2(num_outcomes)
      x.max_entropy.should be_within(0.01).of(expected_H_max)
    end
  end

  context "information_content" do
    it "returns the information content (unexpectedness) associated with a particular outcome" do
      num_outcomes = 5
      x = Math::RandomVariable.new(num_outcomes)
      x.add_possible_outcome(outcome=0, num_observations=1)
      x.add_possible_outcome(outcome=1, num_observations=3)
      prob_of_outcome = 3.0 / 4.0
      expected_ic = Math.log2(1.0 / prob_of_outcome)
      x.information_content(outcome=1).should be_within(0.01).of(expected_ic)
    end
    it "returns max_information_content for zero-probability events" do
      num_outcomes = 5
      x = Math::RandomVariable.new(num_outcomes)
      x.add_possible_outcome(outcome=0, num_observations=1)
      x.add_possible_outcome(outcome=1, num_observations=3)
      expected_ic = Math::RandomVariable.max_information_content
      x.information_content(outcome=2).should be_within(0.01).of(expected_ic)
    end
  end

end
