#!/usr/bin/env ruby

class Listener
  def initialize
    @critics = []
  end

  def add_critic(c)
    @critics.push c
  end

  def listen(notes, logging=false)
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

end
