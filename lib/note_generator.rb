#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'

class NoteGenerator
  def initialize
    @pitch_generator = PitchGenerator.new
    @duration_generator = DurationGenerator.new
  end

  def get_critics
    critics =  @pitch_generator.get_critics 
    critics += @duration_generator.get_critics
    return critics
  end

  def reset
    @pitch_generator.reset
    @duration_generator.reset
  end

  def generate
    return Note.new(@pitch_generator.generate, @duration_generator.generate)
  end
end
