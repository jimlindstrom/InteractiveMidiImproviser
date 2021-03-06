#!/usr/bin/env ruby

module Music
  
  class NoteQueue < Array
    LOGGING = false

    include CanDetectMeter
    include CanDetectPhrases
  
    def self.from_event_queue(evq)
      iois = evq.get_interonset_intervals + [ evq.get_last_duration ]
      ioi_array = Midi::IOIArray.new(iois.dup)
      q_ret = ioi_array.quantize!
  
      notes = NoteQueue.new
      notes.tempo = q_ret[:q]

      iois.zip(evq.get_durations).zip(evq.get_pitches).map{|x| x.flatten}.each do |ioi, duration, pitch|
        note_dur = (duration         / q_ret[:q]).round
        rest_dur = ((ioi - duration) / q_ret[:q]).round

        if note_dur < 0 or note_dur >= Duration.num_values
          puts "can't convert event queue to note queue due to bogus ioi: #{note_dur}"
          return nil 
        elsif pitch < 0 or pitch >= Pitch.num_values
          puts "can't convert event queue to note queue due to bogus pitch: #{pitch}"
          return nil 
        else
          notes.push Note.new(Pitch.new(pitch), Duration.new(note_dur))
        end

        next if rest_dur < 1

        if rest_dur < 0 or rest_dur >= Duration.num_values
          puts "can't convert event queue to note queue due to bogus ioi: #{rest_dur}"
          return nil 
        else
          notes.push Rest.new(Duration.new(rest_dur))
        end
      end
      
      return notes
    end
  
    def to_event_queue
      raise ArgumentError.new("tempo must be set") if @tempo.nil? 

      duration_to_timestamp = 60.0 / @tempo * 200.0
  
      eq = Midi::EventQueue.new
      timestamp = 0
      self.each do |note|
        case note
          when Music::Note
            eq.enqueue Midi::NoteOnEvent.new({
                         :pitch     => note.pitch.val,
                         :velocity  => 100,
                         :timestamp => timestamp })
      
            timestamp += note.duration.val * duration_to_timestamp
            eq.enqueue Midi::NoteOffEvent.new({
                         :pitch     => note.pitch.val,
                         :velocity  => 100,
                         :timestamp => timestamp })
          when Music::Rest
            timestamp += note.duration.val * duration_to_timestamp
          else
            raise RuntimeError.new("unexpected class: #{note.class}")
        end
  
      end 
  
      return eq
    end
  
    def beat_array
      beats = []
      prev = nil
      self.each do |note|
        b = Music::Beat.new
        b.prev_note = prev
        b.cur_note = note
        beats.push b
  
        (note.duration.val-1).times do
          beats.push nil
        end
  
        prev = note
      end
      return beats
    end

    def analyze!
      return if !@have_done_analysis.nil?    
      @have_done_analysis = true
  
      tag_with_notes_left
      create_intervals
    end

  private
  
    def tag_with_notes_left
      self.each_with_index do |item, idx|
        item.analysis[:notes_left] = self.length - 1 - idx
      end
    end

    def create_intervals
      prev = nil
      self.each do |cur|
        if !prev.nil?
          i = Music::Interval.calculate(prev.pitch, cur.pitch)
          prev.analysis[:interval_after] = i
          cur.analysis[:interval_before] = i

          di = Music::DistanceInterval.new(prev, cur)
          prev.analysis[:distance_interval_after] = di
          cur.analysis[:distance_interval_before] = di
        end
        prev = cur
      end
    end


  end

end

