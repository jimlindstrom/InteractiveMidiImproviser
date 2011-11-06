# markov_state_spec.rb

require 'markov/combined_cdf'

describe Markov::CombinedCDF do

  before(:each) do
  end
   
  describe "#add_possible_next_states" do
    it "builds a markov state by observing the given next states" do
      @combo_cdf = Markov::CombinedCDF.new(3)

      a = { }
      a[:total_observations] = 6
      a[:possible_next_states] = [ ]
      a[:possible_next_states].push({:next_state => 0, :num_observations => 4})
      a[:possible_next_states].push({:next_state => 1, :num_observations => 2})
      @combo_cdf.add_possible_next_states a

      b = { }
      b[:total_observations] = 1
      b[:possible_next_states] = [ ]
      b[:possible_next_states].push({:next_state => 0, :num_observations => 1})
      @combo_cdf.add_possible_next_states b

      @combo_cdf.possible_next_states[:possible_next_states].should ==
          [ { :next_state => 0, :num_observations => 5 },
            { :next_state => 1, :num_observations => 2 } ]
    end
  end

end
