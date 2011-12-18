#!/usr/bin/env ruby

class Listener
  LOGGING = true

  def initialize
    @critics = []
  end

  def add_critic(c)
    @critics.push c
  end

  def listen(notes, logging=false)
    return if !analyze_note_queue(notes)

    @critics.each { |c| c.reset }

    if logging
      str = log("note")
      @critics.each { |c| str += log(String(c.class)) }
      puts str if logging
    end

    notes.each do |n| 
      str = log("#{n.pitch.val}, #{n.duration.val}") if logging
      @critics.each do |c| 
        surprise = c.listen(n) 
        str += log(String(surprise)) if logging
      end
      puts str if logging
    end
  end

  private

  def log(str,str_len=10,pad_len=2) # generate a fixed-width string, and pad it
    s = str[0..(str_len-1)]
    until (s.length == str_len) do
      s += " "
    end
    s += " "*pad_len
    return s
  end

  def analyze_note_queue(notes)
    if notes.detect_meter
      puts "\tmeter: #{notes.meter.inspect}" if LOGGING
    else
      puts "\tfailed to detect meter. ignoring stimulus." if LOGGING
      return false # FIXME: figure out a way to listen with only partial info (no meter)
    end
    notes.tag_with_notes_left
    return true
  end

end
