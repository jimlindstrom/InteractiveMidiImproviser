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

    DIST_WEIGHT = 3.0 # increasing this favors phrases that contain low-distance intervals
    SIM_A = 1.0 # increasing this favors phrases that are longer
    SIM_B = 2.0 # increasing this favors phrases that are similar to a high number of phrases
    SIM_C = 3.0 # ?
    DUR_DEV_WEIGHT = 250.0 # increases this favors phrases that are closer to the mean duration

    def score(do_logging=false)
      # penalize really short or long phrases
      duration_penalty = case 
        when duration >= 4 then    0
        when duration == 3 then -100
        when duration == 2 then -400
        when duration <= 1 then -800
      end
      duration_penalty += case 
        when  length >= 12                  then   -1*((length*4)**1.25)
        when (length >=  3 and length < 12) then    0
        when  length ==  2                  then -150
        when  length <=  1                  then -400
      end
      total = duration_penalty

      # first penalize for the total distance
      total -= DIST_WEIGHT*total_distance

      # now add a premium for similarity to other phrases
      filtered_similarity = @phrase_similarity.select{ |x| x > 0.3 }
      if filtered_similarity.empty?
        similarity = 0.0
        mean_similarity = 0.0
        similarity_weight = 0
      else
        mean_similarity = filtered_similarity.inject(0.0){|s,x| s+x} / filtered_similarity.length.to_f
        similarity = (self.length**SIM_A) * (filtered_similarity.length**SIM_B) / (10.0**(SIM_C*mean_similarity)) 
        similarity_weight = 2
        total += similarity_weight*similarity
      end

      # finally, subtract a penalty for being significantly different from the mean phrase length
      total -= DUR_DEV_WEIGHT*duration_deviance

      puts "\t\tscore (#{sprintf("%2d", @start_idx)}-#{sprintf("%2d", @end_idx)}): #{sprintf("% 4d", duration_penalty)} " +
           "- #{DIST_WEIGHT}*#{sprintf("%5.1f", total_distance)} " +
           "+ #{similarity_weight}*((#{sprintf("%2d", self.length)}^#{SIM_A.round})*(#{filtered_similarity.length}^#{SIM_B.round})" + 
           "/(10.0^(#{SIM_C.round}*#{sprintf("%4.3f", mean_similarity)}))) " +
           "- #{DUR_DEV_WEIGHT}*#{sprintf("%5.3f", duration_deviance)} " +
           "= #{sprintf("% 4d", duration_penalty)} " +
           "- #{sprintf("% 6.1f", DIST_WEIGHT*total_distance)} " +
           "+ #{sprintf("% 7.3f", similarity_weight*similarity)} " +
           "- #{sprintf("% 6.1f", DUR_DEV_WEIGHT*duration_deviance)} " +
           "= #{sprintf("% 6.1f", total)}" if do_logging

      return total
    end

    def split_at_a_big_interval
      puts "\tsplit_at_a_big_interval" if LOGGING

      # choose a spot to split it
      indices = @start_idx..(@end_idx-1)
      puts "\t\tindices: #{indices.inspect}" if LOGGING

      x = Math::RandomVariable.new(@note_queue.length)
      indices.zip(@note_queue[indices]).each do |y|
        x.add_possible_outcome(outcome=y[0], num_observations=1.0+((y[1].analysis[:distance_interval_after].distance || 0.0)*2))
      end
      idx = x.choose_outcome
      puts "\t\tsplitting at: #{idx}" if LOGGING

      # generate the new phrase
      new_phrase = Phrase.new(@note_queue, idx+1, @end_idx)
      @end_idx = idx
      return new_phrase
    end

    private

    def total_distance
      within_dist = 0.0
      if length > 1
        within_dist += notes[0..-2].inject(0.0) { |x, note| x + note.analysis[:distance_interval_after].distance }
        #within_dist = within_dist * 0.99**length # tried adding this to incentivize MORE phrase boundaries. couldn't make it work though..
      end

      border_dist = 0.0
      if !notes.last.analysis[:distance_interval_after].nil?
        border_dist = notes.last.analysis[:distance_interval_after].distance
      end

      return within_dist - border_dist
    end

  end
 
end

