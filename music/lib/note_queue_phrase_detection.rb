#!/usr/bin/env ruby

module Music
  $phrase_similarity_cache = {}
end

module CanDetectPhrases
  LOGGING = false # true
 
  attr_accessor :phrases

  MAX_ATTEMPTS = 3

  def detect_phrases
    return false if self.length < 2 # we need >= 2 per group, and at least one group

    analyze!
    $phrase_similarity_cache = {} # reset the phase similarity queue (FIXME: not threadsafe or well architected)
    @phrases = Music::PhraseList.initial(self)
    attempts = MAX_ATTEMPTS.times.collect { new_phrase_detection_attempt }

    if LOGGING
      puts "\tSummary of best attempts:"
      attempts.each { |cur_phrases| puts "\t\t#{cur_phrases.to_s}" }
    end

    return true # FIXME: under what condition could we return false?
  end

private

  MAX_RETRIES =  35
  MAX_ITERS   = 150

  def new_phrase_detection_attempt
    best_phrases = Music::PhraseList.initial(self)

    retries = 0
    iter    = 0

    while (iter < MAX_ITERS) and (retries < MAX_RETRIES)
      tactic = best_phrases.choose_tactic

      puts "detect_phrases - iteration #{iter}, tactic #{tactic}" if LOGGING
      puts "\tbefore:       #{best_phrases.to_s}" if LOGGING
      cur_phrases = best_phrases.clone
      cur_phrases.send(tactic)
      puts "\tafter:        #{cur_phrases.to_s}" if LOGGING
      puts "\tcur_score:    #{cur_phrases.score}" if LOGGING
      puts "\tbest_score:   #{best_phrases.score}" if LOGGING

      if cur_phrases.score > best_phrases.score
        retries = 0
        best_phrases = cur_phrases
      else
        retries += 1
      end
      iter += 1
    end
    puts  "iter: #{iter}, retries: #{retries}, score: #{best_phrases.score}"

    if best_phrases.score > @phrases.score
      @phrases = best_phrases
    end

    return best_phrases
  end

end

