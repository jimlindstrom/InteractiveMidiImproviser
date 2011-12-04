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
    @note_generator.reset
    response = NoteQueue.new

    # FIXME: replace this with a critic / random variable
    meter = Meter.random
    beat_position = meter.initial_beat_position

    # FIXME: replace this with a critic / random variable
    max_num_notes = 8
    num_notes = (rand*max_num_notes).round

    num_notes.times do 
      # generate another note
      response.push @note_generator.generate

      # update the last note with its beat position
      response.last.analysis[:beat_position] = beat_position
      beat_position += response.last.duration

      # FIXME: there needs to be a test around this. It was missing
      get_critics.each { |critic| critic.listen response.last } 
    end

    return response
  end
end
