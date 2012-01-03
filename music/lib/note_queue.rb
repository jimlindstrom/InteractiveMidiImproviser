#!/usr/bin/env ruby

module Music
  
  class NoteQueue < Array
    LOGGING = false

    include CanDetectMeter
    include CanDetectPhrases
  
    def self.from_event_queue(evq)
      iois = Midi::IOIArray.new( evq.get_interonset_intervals + [ evq.get_last_duration ] )
      q_ret = iois.quantize!
  
      notes = NoteQueue.new
      notes.tempo = q_ret[:q]
      iois.zip(evq.get_pitches).each do |ioi, pitch|
        if ioi < 0 or ioi >= Duration.num_values
          puts "can't convert event queue to note queue due to bogus ioi: #{ioi}"
          return nil 
        elsif pitch < 0 or pitch >= Pitch.num_values
          puts "can't convert event queue to note queue due to bogus pitch: #{pitch}"
          return nil 
        else
          notes.push Note.new(Pitch.new(pitch), Duration.new(ioi))
        end
      end
      
      return notes
    end
  
    def to_event_queue
      raise ArgumentError.new("tempo must be set") if @tempo.nil? 
  
      eq = Midi::EventQueue.new
      timestamp = 0
      self.each do |note|
        eq.enqueue Midi::NoteOnEvent.new({
                     :pitch     => note.pitch.val,
                     :velocity  => 100,
                     :timestamp => timestamp })
  
        timestamp += note.duration.val * @tempo
        eq.enqueue Midi::NoteOffEvent.new({
                     :pitch     => note.pitch.val,
                     :velocity  => 100,
                     :timestamp => timestamp })
  
      end 
  
      return eq
    end
  
    def tag_with_notes_left
      self.each_with_index do |item, idx|
        item.analysis[:notes_left] = self.length - 1 - idx
      end
    end

  end

end

