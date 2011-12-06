#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'

module Midi

  # Inter-onset interval (IOI) = the time delta between the start of two consecutive notes 
  class IOIArray < Array
    
    def evaluate_quantizer(q)
      b    = self.map{|x| x.to_f/q}
      br   = b.map{|x| x.round}
      errs = b.zip(br).map { |x| (x[0]-x[1]).to_f / x[0].to_f }
      errs.collect!{ |x| x*x }
      err  = errs.inject{|sum,el| sum + el}
    end
    
    def quantize!
      # choose parameters
      span = 2 * (self.max - self.min).to_f / ((self.min.to_f)+0.5)
      bounded_span = [[span, 1].max, 6].min # put some bounds on it
      num_segs  = (5 + bounded_span).round
      max_depth = (3 + bounded_span).round
      #puts "span: #{span}, num_segs: #{num_segs}, max_depth: #{max_depth}"

      # find the quantization value
      q_ret = self.quantize_helper(self.min.to_f, self.max.to_f, num_segs, max_depth)

      # do the quantizing
      self.collect! {|x| (x/q_ret[:q]).round }
      return q_ret
    end

  protected

    def quantize_helper(q1, q2, num_segs, max_depth) # FIXME: make private?
      delta=(q2-q1)/(num_segs-1).to_f
      qs=[q1.to_f]
      (num_segs-1).times { qs.push(qs.last+delta) }
    
      abs_errs  = qs.collect{|q| evaluate_quantizer(q).abs}
      min_err   = abs_errs.min
      min_idx   = abs_errs.index(min_err)
      min_err_q = qs[min_idx]
    
      if max_depth == 0
        return { :q => min_err_q, :err => min_err }
      else
        if min_idx == 0
          return quantize_helper(qs[0], qs[1], num_segs, max_depth-1)
        elsif min_idx == num_segs-1
          return quantize_helper(qs[num_segs-2], qs[num_segs-1], num_segs, max_depth-1)
        else
          return quantize_helper(qs[min_idx-1], qs[min_idx+1], num_segs, max_depth-1)
        end
      end
    end

  end
  
end
