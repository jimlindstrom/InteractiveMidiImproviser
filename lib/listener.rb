#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'

class Listener
  def initialize
    @critics = []
  end

  def add_critic(c)
    @critics.push c
  end

  def listen(notes)
    @critics.each { |c| c.reset }
    notes.each { |n| @critics.each { |c| c.listen(n) } }
  end
end
