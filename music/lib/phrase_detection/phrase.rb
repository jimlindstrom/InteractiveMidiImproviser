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

    def score(do_logging=false)
      total = 0.0 

      # first penalize for the total distance
      total -= 3*total_distance

      # now add a premium for similarity to other phrases
      if @phrase_similarity.empty? or (filtered_similarity = @phrase_similarity.select{ |x| x > 0.3 }).empty?
        similarity = 0.0
        mean_similarity = 0.0
        similarity_weight = 0
      else
        mean_similarity = filtered_similarity.inject(0.0){|s,x| s+x} / filtered_similarity.length.to_f
        similarity = (self.length**1.0) * (filtered_similarity.length**2.0) / (10.0**(3.0*mean_similarity)) 
        similarity_weight = 2
        total += 2*similarity
      end

      # finally, subtract a penalty for being significantly different from the mean phrase length
      total -= 120.0*duration_deviance

      puts "\t\tscore (#{@start_idx}-#{@end_idx}): 0.0 " +
           "- 3*#{(1000.0*total_distance).round/1000.0} " +
           "+ #{similarity_weight}*((#{self.length}^1)*(#{@phrase_similarity.length}^2)/(10.0^(3*#{(1000*mean_similarity).round/1000.0}))) " +
           "- 120.0*#{(1000.0*duration_deviance).round/1000.0} " +
           "= 0 " +
           "- #{(1000.0*3*total_distance).round/1000.0} " +
           "+ #{(1000.0*2*similarity).round/1000.0} " +
           "- #{(1000.0*120*duration_deviance).round/1000.0} " +
           "= #{(1000.0*total).round/1000.0}" if do_logging

      return total
    end

    # UNTESTED

    def split_at_a_big_ioi
      puts "\tsplit_at_a_big_ioi" if LOGGING

      # choose a spot to split it
      indices = @start_idx..(@end_idx-1)
      puts "\t\tindices: #{indices.inspect}" if LOGGING

      x = Math::RandomVariable.new(@note_queue.length)
      indices.zip(@note_queue[indices]).each do |y|
        if y[1].analysis[:interval_after].class == Music::LBDMInterval
          x.add_possible_outcome(outcome=y[0], num_observations=1.0+((y[1].analysis[:interval_after].s || 0.0)*2))
        elsif y[1].analysis[:interval_after].class == Music::DistInterval
          x.add_possible_outcome(outcome=y[0], num_observations=1.0+((y[1].analysis[:interval_after].distance || 0.0)*2))
        else
          raise RuntimeError.new("Unknown interval type #{y[1].analysis[:interval_after].class}")
        end
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

    private

    def total_distance
      return total_distance_lbdm if notes.first.analysis[:interval_after].class == Music::LBDMInterval
      return total_distance_dist if notes.first.analysis[:interval_after].class == Music::DistInterval
      return 0.0                 if notes.first.analysis[:interval_after].class == NilClass

      raise RuntimeError.new("Unknown interval type #{notes.first.analysis[:interval_after].class}")
    end

    def total_distance_lbdm
      within_dist = 0.0
      if @end_idx > @start_idx
        within_dist += notes[0..-2].inject(0.0) { |x, note| x + note.analysis[:interval_after].s }
      end

      border_dist = 0.0
      if !notes.last.analysis[:interval_after].nil?
        border_dist = notes.last.analysis[:interval_after].s
      end

      return within_dist - border_dist
    end

    def total_distance_dist
      within_dist = 0.0
      if length > 1
        within_dist += notes[0..-2].inject(0.0) { |x, note| x + note.analysis[:interval_after].distance }
      end

      border_dist = 0.0
      if !notes.last.analysis[:interval_after].nil?
        border_dist = notes.last.analysis[:interval_after].distance
      end

      return within_dist - border_dist
    end

  end
 
end

