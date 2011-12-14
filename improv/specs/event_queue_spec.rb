#!/usr/bin/env ruby 

# EventQueue
# 	ToNoteQueue
# 	 	Extract Pitches
# 	  	Extract Durations (IOIs)
# 			# Use IOIs (NoteOn-to-NoteOn) when next NoteOn exists
# 			# Use Duration (NoteOn-to-NoteOff) when no more NoteOn's (last note)
# 	  	Quantize Durations & Find Tempo

require 'spec_helper'
 
describe Midi::EventQueue do
  before do
  end

  context ".reset" do
    it "should ..." do
    end
  end

  context ".listen" do
    it "should ..." do
    end
  end

  context ".get_expectations" do
    it "should ..." do
    end
  end
end
