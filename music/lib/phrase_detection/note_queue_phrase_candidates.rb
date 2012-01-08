#!/usr/bin/env ruby

module NoteQueuePhraseCandidates_LBDMAlgorithm
  LOGGING = false

  def create_intervals
    prev = nil
    self.each do |cur|
      if !prev.nil?
        i = Music::LBDMInterval.new(prev, cur)
        prev.analysis[:interval_after] = i
        cur.analysis[:interval_before] = i
      end
      prev = cur
    end
    self.each do |cur|
      if !cur.analysis[:interval_before].nil? and !cur.analysis[:interval_after].nil?
        cur.analysis[:interval_after ].prev_interval = cur.analysis[:interval_before]
        cur.analysis[:interval_before].next_interval = cur.analysis[:interval_after ]
      end
    end
    self.first.analysis[:interval_after ].prev_interval = self[1].analysis[:interval_before]
    self.last.analysis[:interval_before].next_interval = self[-2].analysis[:interval_after ]
  end

  def phrase_boundary_candidates
    m = []

    m.push 0 if (self[0].analysis[:interval_after].s > self[1].analysis[:interval_after].s)

    (0..(self.length-2)).each do |idx|
      s_cur  = self[idx  ].analysis[:interval_after].s 
      neighbors = []
      neighbors.push self[idx-2].analysis[:interval_after].s if (idx-2) >= 0
      neighbors.push self[idx-1].analysis[:interval_after].s if (idx-1) >= 0
      neighbors.push self[idx+1].analysis[:interval_after].s if (idx+1) <= (self.length-2)
      neighbors.push self[idx+2].analysis[:interval_after].s if (idx+2) <= (self.length-2)

      mean_neighbor_score = neighbors.inject(0.0){|x,s| x+s} / neighbors.length.to_f
      m.push idx if (s_cur >= neighbors.max)
    end

    return m
  end

  def print_phrase_boundary_candidates(actual_boundaries)
    candidates = phrase_boundary_candidates

    self.each_with_index do |note, idx|
      puts "#{note.pitch.val} " +
           "#{note.duration.val}"
      i = note.analysis[:interval_after]
      if !i.nil?
        is_candidate = candidates.include?(idx)          ? "[Dist. Peak]"    : ""
        is_start     = actual_boundaries.include?(idx+1) ? "[Actual Phrase]" : ""
        puts "     > " +
             "#{(i.x*       1000.0).round/1000.0} " +
             "#{(i.r_before*1000.0).round/1000.0} " +
             "#{(i.r_after* 1000.0).round/1000.0} " +
             "#{(i.s*       1000.0).round/1000.0} " +
             "#{is_candidate} #{is_start}"
      end
    end
  end

end

module NoteQueuePhraseCandidates_DistanceAlgorithm
  LOGGING = false

  def create_intervals
    prev = nil
    self.each do |cur|
      if !prev.nil?
        i = Music::DistInterval.new(prev, cur)
        prev.analysis[:interval_after] = i
        cur.analysis[:interval_before] = i
      end
      prev = cur
    end
  end

  def phrase_boundary_candidates
    m = []

    m.push 0 if (self[0].analysis[:interval_after].d > self[1].analysis[:interval_after].d)

    (1..(self.length-3)).each do |idx|
      d_prev = self[idx-1].analysis[:interval_after].d 
      d_cur  = self[idx  ].analysis[:interval_after].d 
      d_next = self[idx+1].analysis[:interval_after].d 

      m.push idx if (d_cur > d_prev) and (d_cur > d_next)
    end

    return m
  end

  def print_phrase_boundary_candidates(actual_boundaries)
    candidates = phrase_boundary_candidates

    self.each_with_index do |note, idx|
      puts "#{note.pitch.val} " +
           "#{note.duration.val}"
      i = note.analysis[:interval_after]
      if !i.nil?
        is_candidate = candidates.include?(idx)          ? "[Dist. Peak]"    : ""
        is_start     = actual_boundaries.include?(idx+1) ? "[Actual Phrase]" : ""
        puts "     > " +
             "#{(i.d*1000.0).round/1000.0} " +
             "#{is_candidate} " +
             "#{is_start}"
      end
    end
  end
end

module NoteQueuePhraseCandidates_DistanceAndSimilarityAlgorithm
  LOGGING = false

  def create_intervals
    create_dist_intervals
    tag_notes_with_similarity_scores
    tag_similarity_peaks
    tag_notes_with_dist_and_similarity
  end

  def phrase_boundary_candidates
    m = []

    (0..(self.length-1)).each do |idx|
      s_cur  = self[idx].analysis[:dist_and_similarity_score] 
      neighbors = []
      neighbors.push self[idx-2].analysis[:dist_and_similarity_score] if (idx-2) >= 0
      neighbors.push self[idx-1].analysis[:dist_and_similarity_score] if (idx-1) >= 0
      neighbors.push self[idx+1].analysis[:dist_and_similarity_score] if (idx+1) <= (self.length-2)
      neighbors.push self[idx+2].analysis[:dist_and_similarity_score] if (idx+2) <= (self.length-2)

      m.push idx if (s_cur >= neighbors.max)
    end

    return m
  end

  def print_phrase_boundary_candidates(actual_boundaries)
    candidates = phrase_boundary_candidates

    self.each_with_index do |note, idx|
      is_candidate = candidates.include?(idx)        ? "[Peak]"          : ""
      is_start     = actual_boundaries.include?(idx) ? "[Actual Phrase]" : ""
      puts "#{note.pitch.val} " +
           "#{note.duration.val} " +
           "#{note.analysis[:bsm_score].round} " +
           "#{note.analysis[:similarity_peak_score]} " +
           "#{note.analysis[:dist_and_similarity_score]} " +
           "#{is_candidate} " +
           "#{is_start}"
      i = note.analysis[:interval_after]
      if !i.nil?
        puts "     > " +
             "#{(i.d*1000.0).round/1000.0}"
      end
    end
  end

  private

  def create_dist_intervals
    prev = nil
    self.each do |cur|
      if !prev.nil?
        i = Music::DistInterval.new(prev, cur)
        prev.analysis[:interval_after] = i
        cur.analysis[:interval_before] = i
      end
      prev = cur
    end
  end

  def tag_notes_with_similarity_scores
    bsm = Music::BeatSimilarityMatrix.new(self.beat_array)
    cur_diag = 0
    notes_left = self.length+1
    self.each do |note|
      note.analysis[:bsm_score] = 10000.0 * ( (bsm.mean_of_diag(cur_diag) ** 0.5) / notes_left**2.5 )
      cur_diag += note.duration.val
      notes_left -= 1
    end
  end

  def tag_similarity_peaks
    (0..(self.length-1)).each do |idx|
      s_cur  = self[idx  ].analysis[:bsm_score]
      neighbors = []
      neighbors.push self[idx-2].analysis[:bsm_score] if (idx-2) >= 0
      neighbors.push self[idx-1].analysis[:bsm_score] if (idx-1) >= 0
      neighbors.push self[idx+1].analysis[:bsm_score] if (idx+1) <= (self.length-1)
      neighbors.push self[idx+2].analysis[:bsm_score] if (idx+2) <= (self.length-1)

      mean_neighbor_score = neighbors.inject(0.0){|x,s| x+s} / neighbors.length.to_f
      self[idx].analysis[:similarity_peak_score] = (1000.0*(s_cur / mean_neighbor_score).round)/1000.0
      if (s_cur >= neighbors.max)
        self[idx].analysis[:similarity_peak] = "[Similarity Peak]"
      else
        self[idx].analysis[:similarity_peak] = ""
      end
    end
  end

  def tag_notes_with_dist_and_similarity
    (0..(self.length-1)).each do |idx|
      score = 1.0
      score *= (1.0 + self[idx-1].analysis[:similarity_peak_score]**0.5) if (idx-1) >= 0
      score *= (1.0 + self[idx  ].analysis[:similarity_peak_score])
      score *= (1.0 + self[idx+1].analysis[:similarity_peak_score]**0.5) if (idx+1) < self.length
      score *= (1.0 + self[idx  ].analysis[:interval_before].d**0.25) if !self[idx].analysis[:interval_before].nil?
      score *= (1.0 + self[idx  ].analysis[:interval_after ].d**0.25) if !self[idx].analysis[:interval_after ].nil?

      self[idx].analysis[:dist_and_similarity_score] = (1000.0*score).round/1000.0
    end

  end
end

module NoteQueuePhraseCandidates
  #include NoteQueuePhraseCandidates_LBDMAlgorithm
  #include NoteQueuePhraseCandidates_DistanceAlgorithm
  include NoteQueuePhraseCandidates_DistanceAndSimilarityAlgorithm
end

