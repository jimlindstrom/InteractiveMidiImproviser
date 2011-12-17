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
      str = "\t"
      @critics.each { |c| str += "\t#{c.class}" }
      puts str
    end

    notes.each do |n| 
      str = "#{n.pitch.val}, #{n.duration.val}\t" if logging
      @critics.each do |c| 
        surprise = c.listen(n) 
        str += "#{surprise}\t" if logging
      end
      puts str if logging
    end
  end
end
