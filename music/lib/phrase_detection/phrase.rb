#!/usr/bin/env ruby

module Music

  class Phrase
    LOGGING = false # true

    attr_accessor :start_idx, :end_idx
    attr_accessor :phrase_similarity
    attr_accessor :duration_deviance

    def initialize(note_queue, start_idx, end_idx)
      raise ArgumentError.new("note_queue cannot be nil") if note_queue.nil?
      raise ArgumentError.new("start_idx must be >= 0") if start_idx < 0
      raise ArgumentError.new("end_idx must be >= start_idx") if start_idx > end_idx
      raise ArgumentError.new("end_idx must be < length") if end_idx >= note_queue.length

      @note_queue = note_queue
      @start_idx  = start_idx
      @end_idx    = end_idx

      @phrase_similarity  = []
      @duration_deviance = 0.0
    end

    def notes
      @note_queue[@start_idx..@end_idx]
    end

    def length
      @end_idx - @start_idx + 1
    end

    def duration
      notes.inject(0.0) { |x, note| x + note.duration.val }
    end

    def total_distance
      within_dist = 0.0
      if @end_idx > @start_idx
        within_dist += notes[0..-2].inject(0.0) { |x, note| x + note.analysis[:interval_after].s }
      end

      border_dist = 0.0
      if !notes.last.analysis[:interval_after].nil?
        border_dist = notes.last.analysis[:interval_after].s
      end

      return within_dist - border_dist # or divide by?
    end

    def score(do_logging=false)
      total = 0.0 

      # first penalize for the total distance
      total -= 3*total_distance

      # now add a premium for similarity to other phrases
      #similarity = 1.0 - (1.0 / (1.0 + @phrase_similarity))
      if @phrase_similarity.empty? or (filtered_similarity = @phrase_similarity.select{ |x| x > 0.4 }).empty?
        similarity = 0.0
        mean_similarity = 0.0
      else
        mean_similarity = filtered_similarity.inject(0.0){|x,n| x+n} / filtered_similarity.length.to_f
        similarity = (self.length**1.0) * (filtered_similarity.length**2.0) / (10.0**(3.0*mean_similarity)) 
        total += 2*similarity
      end

      # finally, subtract a penalty for being significantly different from the mean phrase length
      total -= 1.0*duration_deviance

      puts "\t\tscore (#{@start_idx}-#{@end_idx}): 400.0 " +
           "- 3*#{(1000.0*total_distance).round/1000.0} " +
           "+ 2*((#{self.length}^1)*(#{@phrase_similarity.length}^2)/(10.0^(3*#{(1000*mean_similarity).round/1000.0}))) " +
           "- 1.0*#{(1000.0*duration_deviance).round/1000.0} " +
           "= 400 " +
           "- #{(1000.0*3*total_distance).round/1000.0} " +
           "+ #{(1000.0*2*similarity).round/1000.0} " +
           "- #{(1000.0*1*duration_deviance).round/1000.0} " +
           "= #{(1000.0*total).round/1000.0}" if do_logging

      return total
    end

    def split_at_a_big_ioi
      puts "\tsplit_at_a_big_ioi" if LOGGING

      # choose a spot to split it
      indices = @start_idx..(@end_idx-1)
      puts "\t\tindices: #{indices.inspect}" if LOGGING

      x = Math::RandomVariable.new(@note_queue.length)
      indices.zip(@note_queue[indices]).each do |y|
        x.add_possible_outcome(outcome=y[0], num_observations=1.0+((y[1].analysis[:interval_after].s || 0.0)*2))
      end
      idx = x.choose_outcome
      puts "\t\tsplitting at: #{idx}" if LOGGING

      # flip a coin to decide which side of the IOI we're going to break the phrase at
      if (rand > 0.5) and ((idx+2) <= @end_idx)
        idx += 1
      end

      # generate the new phrase
      new_phrase = Phrase.new(@note_queue, idx+1, @end_idx)
      @end_idx = idx
      return new_phrase
    end
  end
 
end

