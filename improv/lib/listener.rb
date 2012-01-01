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
      str  = to_fixed_width("note")
      str += @critics.map { |c| to_fixed_width(String(c.class)) }.join
      puts str
    end

    notes.each do |n| 
      str = to_fixed_width("#{n.pitch.val}, #{n.duration.val}") if logging

      @critics.each do |c| 
        information_content = c.listen(n)  # FIXME: try splitting up getting info content from listen()ing
        str += to_fixed_width(String(information_content)) if logging
      end

      puts str if logging
    end
  end

  private

  def to_fixed_width(str,str_len=10,pad_len=2)
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
