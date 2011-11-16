#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'

class Improvisor
  def initialize
    @note_generator = NoteGenerator.new
  end

  def get_critics
    @note_generator.get_critics
  end

  def generate
    max_num_notes = 8
    num_notes = (rand*max_num_notes).round

    response = NoteQueue.new
    @note_generator.reset
    num_notes.times do 
      response.push @note_generator.generate
    end

    return response
  end
end
