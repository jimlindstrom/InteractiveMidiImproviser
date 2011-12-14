#!/usr/bin/env ruby

module Music
  
  class Beat
    attr_accessor :prev_note, :cur_note
  
    def interval
      return @interval if !@interval.nil?
  
      if !@prev_note.nil? and !@cur_note.nil?
        @interval = Interval.calculate(@prev_note.pitch, @cur_note.pitch)
      end
      return @interval
    end
  
    def similarity_to(b) # returns 1 for identical; 0 for totally different
      return 0.00 if b.nil?
  
      if self.interval.nil?
        interval_similarity = 0.0
      else
        interval_similarity = self.interval.similarity_to b.interval
      end
  
      note_similarity = @cur_note.pitch.similarity_to b.cur_note.pitch
      duration_similarity = @cur_note.duration.similarity_to b.cur_note.duration
      return (3*interval_similarity + note_similarity + 5*duration_similarity) / 9.0
    end
  
  end

end
