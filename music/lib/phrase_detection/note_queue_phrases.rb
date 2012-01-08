#!/usr/bin/env ruby

# assumes it is included in NoteQueue
module NoteQueuePhrases
  LOGGING = true
 
  attr_accessor :phrases

  def detect_phrases
    return false if self.length < 2 # we need >= 2 per group, and at least one group

    create_intervals

    @phrases = Music::PhraseList.initial(self)
    best_score = @phrases.score

    max_retries = 25
    retries = max_retries

    max_iters = 1000
    iter = 0

    try_again = true
    while try_again
      tactic = choose_tactic

      puts "detect_phrases - iteration #{iter}, tactic #{tactic}" if LOGGING
      puts "\tbefore:       #{@phrases.to_s}" if LOGGING
      cur_attempt = @phrases.clone
      cur_attempt.send(tactic)
      puts "\tafter:        #{cur_attempt.to_s}" if LOGGING
      cur_score   = cur_attempt.score
      puts "\tcur_score:    #{cur_score}" if LOGGING
      puts "\tbest_score:   #{best_score}" if LOGGING

      if cur_score > best_score
        retries = max_retries
        try_again = true
        @phrases   = cur_attempt
        best_score = cur_score
      else
        try_again = (retries -= 1) > 0
      end
      if (iter += 1) >= max_iters
        try_again = false
      end
    end

    return true
  end

private

  def choose_tactic
    if @tactics.nil?
      @tactics = [ :split_a_phrase_at_biggest_ioi,
                   :merge_two_phrases,
                   :shift_boundary_between_two_phrases ]
    end

    # round robin through the tactics
    next_tactic = @tactics.shift
    @tactics.push next_tactic

    return next_tactic
  end

end

