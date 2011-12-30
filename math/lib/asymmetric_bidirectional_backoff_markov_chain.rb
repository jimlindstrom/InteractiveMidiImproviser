#!/usr/bin/env ruby

require 'yaml'

module Math
  
  class AsymmetricBidirectionalBackoffMarkovChain < AsymmetricBidirectionalMarkovChain

    BACK_OFF_SCALING = 0.05

    def initialize(order, lookahead, num_states, num_outcomes)
      super(order, lookahead, num_states, num_outcomes)
      if order == 1
        raise ArgumentError.new("You can't have a backoff chain with order 1, use AsymmetricBidirectionalMarkovChain instead")
      elsif order == 2
        @sub_chain = AsymmetricBidirectionalMarkovChain.new(order-1, lookahead, num_states, num_outcomes)
      elsif order > 2
        @sub_chain = AsymmetricBidirectionalBackoffMarkovChain.new(order-1, lookahead, num_states, num_outcomes)
      end
      reset
    end

    def reset
      super
      @sub_chain.reset if !@sub_chain.nil?
    end
  
    def save(filename)
      super
      sub_filename = filename.gsub(/\./,"_sub.")
      @sub_chain.save(sub_filename)
    end

    def self.load(filename)
      docs = []
      File.open(filename, 'r') do |f|
        YAML.each_document(f) { |d| docs.push d }
      end
      raise RuntimeError.new("bad markov file") if docs.length != 7

      m = AsymmetricBidirectionalBackoffMarkovChain.new(docs[0], docs[1], docs[2], docs[3])
      m.set_internals(docs[4], docs[5], docs[6])

      sub_filename = filename.gsub(/\./,"_sub.")
      if m.order == 2
        m.set_sub_chain AsymmetricBidirectionalMarkovChain.load(sub_filename)
      elsif m.order > 2
        m.set_sub_chain AsymmetricBidirectionalBackoffMarkovChain.load(sub_filename)
      end
      return m
    end
  
    def observe(outcome, steps_left)
      super(outcome, steps_left)
      @sub_chain.observe(outcome, steps_left)
    end
  
    def transition(next_state, steps_left)
      super(next_state, steps_left)
      @sub_chain.transition(next_state, steps_left)
    end
  
    def get_expectations
      # see algorithm: http://www.doc.gold.ac.uk/~mas01mtp/papers/PearceWigginsJNMR04.pdf (p. 2)

      expectations = super
      sub_expectations = @sub_chain.get_expectations

      all_outcomes = Array(0..[expectations.num_outcomes-1, sub_expectations.num_outcomes-1].max)

      all_outcomes.each do |cur_outcome|
        if expectations.observations[cur_outcome] > 0
        elsif expectations.observations[cur_outcome] == 0
          expectations.add_possible_outcome(cur_outcome, BACK_OFF_SCALING * sub_expectations.observations[cur_outcome])
        end
      end

      return expectations
    end

  #protected

    def set_sub_chain(s)
      @sub_chain=s
    end

  end
  
end
