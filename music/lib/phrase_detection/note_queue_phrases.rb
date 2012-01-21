#!/usr/bin/env ruby

# assumes it is included in NoteQueue
module NoteQueuePhrases
  LOGGING = true
 
  attr_accessor :phrases

  def detect_phrases
    return false if self.length < 2 # we need >= 2 per group, and at least one group

    create_intervals

    attempts = []
    @phrases = Music::PhraseList.initial(self)
    phrases_score = @phrases.score

    5.times do |meta_iter|
      best_phrases = Music::PhraseList.initial(self)
      best_score   = best_phrases.score
  
      max_retries = 25
      retries     = max_retries
  
      max_iters = 1000
      iter      = 0
  
      try_again = true
      while try_again
        tactic = choose_tactic
  
        puts "detect_phrases - meta iteration #{meta_iter}, iteration #{iter}, tactic #{tactic}" if LOGGING
        puts "\tbefore:       #{best_phrases.to_s}" if LOGGING
        cur_attempt = best_phrases.clone
        cur_attempt.send(tactic)
        puts "\tafter:        #{cur_attempt.to_s}" if LOGGING
        cur_score   = cur_attempt.score
        puts "\tcur_score:    #{cur_score}" if LOGGING
        puts "\tbest_score:   #{best_score}" if LOGGING
  
        if cur_score > best_score
          retries = max_retries
          try_again = true
          best_phrases = cur_attempt
          best_score   = cur_score
        else
          try_again = (retries -= 1) > 0
        end
        if (iter += 1) >= max_iters
          try_again = false
        end
      end

      attempts.push best_phrases
      if best_score > phrases_score
        @phrases = best_phrases
        phrases_score = best_score
      end
  
    end

    puts "\tSummary of best attempts:" if LOGGING
    attempts.each do |cur_attempt|
      puts "\t\t#{cur_attempt.to_s}" if LOGGING
    end

    return true
  end

private

  def choose_tactic
    if @tactics.nil?
      @tactics = [ :split_a_phrase,
                   :split_all_phrases,
                   :merge_two_phrases,
                   :shift_boundary_between_two_phrases ]
    end

    # round robin through the tactics
    next_tactic = @tactics.shift
    @tactics.push next_tactic

    return next_tactic
  end

end

