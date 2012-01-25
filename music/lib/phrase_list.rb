#!/usr/bin/env ruby

module Music

  class PhraseList < Array
    LOGGING = false # true

    def initialize(note_queue)
      @note_queue = note_queue
    end

    def self.initial(note_queue)
      pl = PhraseList.new(note_queue)
      pl.push Phrase.new(note_queue, start_idx=0, end_idx=note_queue.length-1)
      return pl
    end

    def clone
      pl = PhraseList.new(@note_queue)
      self.each do |phrase|
        pl.push Phrase.new(@note_queue, phrase.start_idx, phrase.end_idx)
      end
      return pl
    end

    def score
      return @score if !@score.nil?

      puts "\tscoring phrases:" if LOGGING
      calculate_phrase_duration_penalty(do_logging=LOGGING)
      calculate_phrase_similarity(do_logging=LOGGING)

      scores = self.collect { |phrase| phrase.score(do_logging=LOGGING) }
      @score = scores.inject(0.0) { |x,s| x + s }
      puts "\t\toverall score:                     " +
           "                                       " +
           "                                       " + 
           "   #{sprintf("% 6.1f", @score)}" if LOGGING

      return @score
    end

    def to_s
      self.collect{|p| "#{p.start_idx}-#{p.end_idx}" }.join(", ")
    end

    # UNTESTED

    def choose_tactic
      if @tactics.nil?
        @tactics = [ :split_all_phrases,
                     :shift_boundary_between_two_phrases,
                     :merge_two_phrases,
                     :shift_boundary_between_two_phrases,
                     :split_a_phrase,
                     :shift_boundary_between_two_phrases ]
      end

#      # Try to rig this so that smarter choices are made
#      # if shortest phrase is quite long, bias toward splitting
#      lengths = self.collect{ |p| p.duration }
#      if lengths.min > 16 and rand > 0.7
#        return :split_all_phrases if rand > 0.4
#        return :split_a_phrase
#      end
#
#      # if long phrase is quite shot, bias toward merging
#      if lengths.max < 5 and rand > 0.7
#        return :merge_two_phrases
#      end
  
      # round robin through the tactics
      next_tactic = @tactics.shift
      @tactics.push next_tactic
  
      return next_tactic
    end
  
    def split_a_phrase # should be useful when there's one outlier that's too long
      @score = nil # if we had scored this phrase list it's now invalidated

      orig_phrase = self[choose_phrase_idx_weighted_by_duration_deviance]
      if orig_phrase.length > 1
        new_phrase = orig_phrase.split_at_a_big_interval
        push new_phrase
        resort!
      end
    end

    def split_all_phrases # should be useful for when we zero in on a good, but too-high-level solution
      @score = nil # if we had scored this phrase list it's now invalidated

      new_phrases = []
      self.each do |orig_phrase|
        if orig_phrase.length > 1
          new_phrase = orig_phrase.split_at_a_big_interval
          new_phrases.push new_phrase
        end
      end
      concat new_phrases
      resort!
    end

    def merge_two_phrases
      @score = nil # if we had scored this phrase list it's now invalidated

      puts "\tmerge_two_phrases" if LOGGING
      return if self.length < 2

      phrase1_idx, phrase2_idx = choose_two_phrases_weighted_by_score

      puts "\t\tmerging phrases #{phrase1_idx} and #{phrase2_idx}" if LOGGING
      self[phrase1_idx].end_idx = self[phrase2_idx].end_idx
      self.delete_at(phrase2_idx)
    end

    def shift_boundary_between_two_phrases
      @score = nil # if we had scored this phrase list it's now invalidated

      puts "\tshift_boundary_between_two_phrases" if LOGGING
      return if self.length < 2

      phrase1_idx, phrase2_idx = choose_two_phrases_weighted_by_score

      if self[phrase1_idx].length>1 and rand>0.5

        possible_num_notes = Array(1..self[phrase1_idx].length)
        x = Math::RandomVariable.new(num_outcomes=possible_num_notes.length+2)
        possible_num_notes.each do |num_notes|
          x.add_possible_outcome(outcome=num_notes, num_observations=1.0/num_notes)
        end
        num_notes = x.choose_outcome

        puts "\t\tgiving #{num_notes} note(s) from phrases #{phrase1_idx} to #{phrase2_idx}" if LOGGING
        self[phrase1_idx].end_idx -= num_notes
        self[phrase2_idx].start_idx -= num_notes

      elsif self[phrase2_idx].length>1

        possible_num_notes = Array(1..self[phrase2_idx].length)
        x = Math::RandomVariable.new(num_outcomes=possible_num_notes.length+2)
        possible_num_notes.each do |num_notes|
          x.add_possible_outcome(outcome=num_notes, num_observations=1.0/num_notes)
        end
        num_notes = x.choose_outcome

        puts "\t\tgiving #{num_notes} note(s) from phrases #{phrase2_idx} to #{phrase1_idx}" if LOGGING
        self[phrase1_idx].end_idx += num_notes
        self[phrase2_idx].start_idx += num_notes
      end
    end

  private

    def median_phrase_duration
      phrase_durations = self.collect{ |p| p.duration }.sort

      median_duration = case (phrase_durations.length%2)
        when 0 then (phrase_durations[(phrase_durations.length/2)-1] + phrase_durations[phrase_durations.length/2]) / 2.0
        when 1 then phrase_durations[phrase_durations.length/2]
      end

      return median_duration
    end

    def calculate_phrase_duration_penalty(do_logging=false)
      self.each { |phrase| phrase.duration_deviance = 0.0 }

      if self.length > 1
        median_duration = median_phrase_duration
        puts "\t\tmedian_duration = #{median_duration}" if do_logging

        self.each do |phrase| 
          if phrase.duration > median_duration
            phrase.duration_deviance = ((phrase.duration - median_duration) / median_duration.to_f)**1.5
          else
            phrase.duration_deviance = ((median_duration - phrase.duration) / phrase.duration.to_f)**1.5
          end
        end
      end
    end

    def calculate_phrase_similarity(do_logging=false)
      self.each { |phrase| phrase.phrase_similarity = [] }

      if self.length > 1
        beat_arrays = self.collect { |phrase| Music::NoteQueue.new(phrase.notes).beat_array }

        puts "\t\tbeat_similarity =" if do_logging
        padding = "x    " if do_logging
        (0..(self.length-2)).each do |x|
          similarities = [] if do_logging
          cache_subkey = "#{self[x].start_idx},#{self[x].end_idx};"

          ((x+1)..(self.length-1)).each do |y|
            cache_key = cache_subkey + "#{self[y].start_idx},#{self[y].end_idx}"
            s = if !$phrase_similarity_cache[cache_key].nil?
              $phrase_similarity_cache[cache_key]
            else
              matrix = BeatCrossSimilarityMatrix.new(beat_arrays[x], beat_arrays[y])
              $phrase_similarity_cache[cache_key] = matrix.max_arithmetic_mean_of_diag(penalize_for_overhang=true)
            end

            similarities.push s if do_logging
            self[x].phrase_similarity.push s
            self[y].phrase_similarity.push s
          end

          puts "\t\t\t" + padding + similarities.map{ |x| sprintf("%0.2f", x) }.join(" ") if do_logging
          padding = "     " + padding if do_logging
        end
      end
    end

    def choose_two_phrases_weighted_by_score
      phrase1_idx = choose_phrase_idx_weighted_by_score
      if phrase1_idx == (self.length-1)
        phrase1_idx -= 1
      elsif (phrase1_idx > 0) and (rand > 0.5)
        phrase1_idx -= 1
      end
      phrase2_idx = phrase1_idx + 1

      return [phrase1_idx, phrase2_idx]
    end

    def choose_phrase_idx_weighted_by_duration_deviance
      choose_phrase_idx_weighted_by_lambda(lambda{|phrase| phrase.duration_deviance})
    end

    def choose_phrase_idx_weighted_by_score
      choose_phrase_idx_weighted_by_lambda(lambda{|phrase| -phrase.score})
    end

    def choose_phrase_idx_weighted_by_lambda(l)
      raise RuntimeError.new("can't choose phrase index for empty phrase list") if self.length==0
      return 0 if self.length==1

      calculate_phrase_similarity
      calculate_phrase_duration_penalty

      scores = self.collect{ |phrase| l.call(phrase) }
      min_score = scores.min
      translated_scores = scores.map{ |s| s-min_score }
      #max_score = translated_scores.max
      #inverse_scores = translated_scores.map{ |s| max_score-s }

      x = Math::RandomVariable.new(num_outcomes=self.length)
      #inverse_scores.each_with_index do |score, idx|
      translated_scores.each_with_index do |score, idx|
        avoid_zero_observations = 0.01
        x.add_possible_outcome(outcome=idx, num_observations=avoid_zero_observations+score)
      end
      idx = x.choose_outcome

      raise RuntimeError.new("idx must be not be nil. #{translated_scores.inspect}") if idx.nil?
      raise RuntimeError.new("idx #{idx} must be in [0, #{self.length-1}]") if idx<0 or idx>=self.length
      return idx
    end

    def resort!
      self.sort!{ |x,y| x.start_idx <=> y.start_idx }
    end
  end

end
