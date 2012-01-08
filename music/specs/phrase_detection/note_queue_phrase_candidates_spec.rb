# midi_event_queue_spec.rb

require 'spec_helper'

describe Music::NoteQueue do

  before(:each) do
  end

  describe "create_intervals" do
    it "should create intervals between each note", :wip=>true do
      vector = $phrasing_vectors["Bring back my bonnie to me"]
      nq = vector[:note_queue]
      nq.create_intervals
      interval_type = nq.collect{ |x| x.analysis[:interval_after].class }.uniq.first
	  expected_interval_types = [Music::LBDMInterval, Music::DistInterval]
      expected_interval_types.include?(interval_type).should be_true
    end
    it "should string together the intervals properly", :wip=>true do
      vector = $phrasing_vectors["Bring back my bonnie to me"]
      nq = vector[:note_queue]
      nq.create_intervals
      nq.each_cons(2) {|x| x[0].analysis[:interval_after].should == x[1].analysis[:interval_before] }
    end

  end

  describe "phrase_boundary_candidates" do
    it "should return an array", :wip=>true do
      vector = $phrasing_vectors["Bring back my bonnie to me"]
      nq = vector[:note_queue]
      nq.create_intervals
      nq.phrase_boundary_candidates.should be_an_instance_of Array
    end

    it "should include at least one candidate near every boundary", :wip=>true do
      num_missed = 0
      total      = 0

      $phrasing_vectors.keys.each do |key|
        vector = $phrasing_vectors[key]
        nq = vector[:note_queue]
        nq.create_intervals

        actual_boundaries = vector[:phrase_boundaries].collect{|p| p[:start_idx] }

        actual_boundaries.each do |b|
          #plausible_boundaries = Array((b-2)..(b+2))
          plausible_boundaries = Array((b-1)..(b+1))

          matched = false
          nq.phrase_boundary_candidates.each do |x|
            if plausible_boundaries.include?(x) 
              matched = true
            end
          end

          num_missed += 1 if matched==false
          total += 1
        end
      end

      (num_missed / total.to_f).should < 0.05
    end

    it "should include very few implausible boundary candidates", :wip=>true do
      num_implausible = 0
      total     = 0

      $phrasing_vectors.keys.each do |key|
        vector = $phrasing_vectors[key]
        nq = vector[:note_queue]
        nq.create_intervals

        actual_boundaries = vector[:phrase_boundaries].collect{|p| p[:start_idx] }
        plausible_boundaries = actual_boundaries.collect{|p| [ p-2, p-1, p, p+1, p+2 ] }.flatten.sort.uniq

        nq.phrase_boundary_candidates.each do |b|
          if !plausible_boundaries.include?(b) 
            num_implausible += 1
          end
          total += 1
        end
      end

      (num_implausible / total.to_f).should < 0.10

    end

    it "shouldn't be overly redundant", :wip=>true do
      extras = 0
      total  = 0

      $phrasing_vectors.keys.each do |key|
        vector = $phrasing_vectors[key]
        nq = vector[:note_queue]
        nq.create_intervals

        actual_boundaries = vector[:phrase_boundaries].collect{|p| p[:start_idx] }

        extras += nq.phrase_boundary_candidates.length
        extras -= actual_boundaries.length

        total  += actual_boundaries.length
      end

      (extras / total.to_f).should < 1.15
    end

    it "DEBUG: print out phrase boundary candidates", :wip => true do
      $phrasing_vectors.keys.each do |key|
        puts 
        puts "#{key}:"
        vector = $phrasing_vectors[key]
        nq = vector[:note_queue]
        nq.create_intervals

        actual_boundaries = vector[:phrase_boundaries].collect{|p| p[:start_idx] }

        nq.print_phrase_boundary_candidates(actual_boundaries)
      end
    end
  end

end
