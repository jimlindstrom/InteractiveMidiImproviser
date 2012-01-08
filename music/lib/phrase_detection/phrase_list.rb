#!/usr/bin/env ruby

module Music

  class PhraseList < Array
    LOGGING = true

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

    def to_s
      self.collect{|p| "#{p.start_idx}-#{p.end_idx}" }.join(", ")
    end

    def score
      puts "\tscoring phrases:" if LOGGING
      calculate_phrase_duration_penalty(do_logging=LOGGING)
      calculate_phrase_similarity(do_logging=LOGGING)

      scores = self.collect { |phrase| phrase.score(do_logging=LOGGING) }
      overall_score = scores.inject(0.0) { |x,s| x + s }

      return overall_score
    end

    def split_a_phrase_at_biggest_ioi
      orig_phrase = self[choose_phrase_idx_weighted_by_score]
      if orig_phrase.length > 1
        new_phrase = orig_phrase.split_at_a_big_ioi
        push new_phrase
        resort!
      end
    end

    def merge_two_phrases
      puts "\tmerge_two_phrases" if LOGGING
      return if self.length < 2

      phrase1_idx = choose_phrase_idx_weighted_by_score
      if phrase1_idx == (self.length-1)
        phrase1_idx -= 1
        phrase2_idx = phrase1_idx + 1
      elsif phrase1_idx == 0
        phrase2_idx = phrase1_idx + 1
      elsif rand>0.5
        phrase1_idx -= 1
        phrase2_idx = phrase1_idx + 1
      else
        phrase2_idx = phrase1_idx + 1
      end

      puts "\t\tmerging phrases #{phrase1_idx} and #{phrase2_idx}" if LOGGING
      self[phrase1_idx].end_idx = self[phrase2_idx].end_idx
      self.delete_at(phrase2_idx)
    end

    def shift_boundary_between_two_phrases
      puts "\tshift_boundary_between_two_phrases" if LOGGING
      return if self.length < 2

      phrase1_idx = choose_phrase_idx_weighted_by_score
      if phrase1_idx == (self.length-1)
        phrase1_idx -= 1
        phrase2_idx = phrase1_idx + 1
      elsif phrase1_idx == 0
        phrase2_idx = phrase1_idx + 1
      elsif rand>0.5
        phrase1_idx -= 1
        phrase2_idx = phrase1_idx + 1
      else
        phrase2_idx = phrase1_idx + 1
      end

      if self[phrase1_idx].length>1 and rand>0.5
        puts "\t\tgiving a note from phrases #{phrase1_idx} to #{phrase2_idx}" if LOGGING
        self[phrase1_idx].end_idx -= 1
        self[phrase2_idx].start_idx -= 1
      elsif self[phrase2_idx].length>1
        puts "\t\tgiving a note from phrases #{phrase2_idx} to #{phrase1_idx}" if LOGGING
        self[phrase1_idx].end_idx += 1
        self[phrase2_idx].start_idx += 1
      end
    end

  private
    def calculate_phrase_duration_penalty(do_logging=false)
      self.each { |phrase| phrase.duration_deviance = 0.0 }

      if self.length > 1
        phrase_durations = self.collect{ |p| p.duration }
        median_duration = phrase_durations[(phrase_durations.length/2).round]
        puts "\t\tmedian_duration = #{median_duration}" if do_logging

        self.each do |phrase| 
          if phrase.duration > median_duration
            phrase.duration_deviance = (phrase.duration / median_duration.to_f)**1.25 
          else
            phrase.duration_deviance = (median_duration / phrase.duration.to_f)**1.25 
          end
        end
      end
    end

    def calculate_phrase_similarity(do_logging=false)
      self.each { |phrase| phrase.phrase_similarity = [] }

      if self.length > 1
        beat_arrays = self.collect { |phrase| Music::NoteQueue.new(phrase.notes).beat_array }

        puts "\t\tbeat_similarity =" if do_logging
        (0..(self.length-2)).each do |x|
          similarities = [] if do_logging
          ((x+1)..(self.length-1)).each do |y|
            matrix = BeatCrossSimilarityMatrix.new(beat_arrays[x], beat_arrays[y])
            #s = matrix.arithmetic_mean_of_diag(0)
            s = matrix.max_arithmetic_mean_of_diag
            similarities.push s if do_logging
            self[x].phrase_similarity.push s
            self[y].phrase_similarity.push s
          end
          puts "\t\t\t" + similarities.map{ |x| String(((x*100).floor)/100.0) }.join(", ") if do_logging
        end
      end
    end

    def choose_phrase_idx_weighted_by_score
      raise RuntimeError.new("can't choose phrase index for empty phrase list") if self.length==0
      return 0 if self.length==1

      calculate_phrase_similarity
      calculate_phrase_duration_penalty

      scores = self.collect{ |phrase| phrase.score }
      min_score = scores.min
      translated_scores = scores.map{ |s| s-min_score }
      max_score = translated_scores.max
      inverse_scores = translated_scores.map{ |s| max_score-s }

      x = Math::RandomVariable.new(num_outcomes=self.length)
      inverse_scores.each_with_index do |score, idx|
        x.add_possible_outcome(outcome=idx, num_observations=score)
      end
      idx = x.choose_outcome

      raise RuntimeError.new("idx #{idx} must be in [0, #{self.length-1}]") if idx<0 or idx>=self.length
      return idx
    end

    def resort!
      self.sort!{ |x,y| x.start_idx <=> y.start_idx }
    end
  end

end
