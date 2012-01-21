#!/usr/bin/env ruby

module Music
  
  class Beat
    attr_accessor :prev_note, :cur_note
  
    def interval # this should really be using the interval that's on note.analysis
      return @interval if !@interval.nil?
  
      if !@prev_note.nil? and !@cur_note.nil?
        @interval = Interval.calculate(@prev_note.pitch, @cur_note.pitch)
      end
      return @interval
    end
   
    def similarity_to(b) # returns 1 for identical; 0 for totally different
      return 0.00 if b.nil?

      if @cur_note.pitch.val == b.cur_note.pitch.val # this should really be moved to note.similarity_to
        # if exactly same pitches, give them a match of 1.00
        pitch_similarity = 1.00
      elsif !self.interval.nil? and !b.interval.nil? and self.interval.val == b.interval.val
        # if exactly same interals, give them a match of 0.90
        pitch_similarity = 0.90
      else
        # otherwise, give the best of the interval or abs. pitch similarity
        interval_similarity  = 0.0 
        interval_similarity  = self.interval.similarity_to b.interval if !self.interval.nil?

        abs_pitch_similarity = @cur_note.pitch.similarity_to b.cur_note.pitch
        pitch_similarity = 0.9 * [ interval_similarity, abs_pitch_similarity ].max
      end

      duration_similarity = @cur_note.duration.similarity_to b.cur_note.duration

      return 0.6*pitch_similarity + 0.4*duration_similarity
    end
  
  end

end
