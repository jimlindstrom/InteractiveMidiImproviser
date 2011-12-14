# beat_spec.rb

require 'spec_helper'

describe Beat do

  before(:each) do
  end

  context "similarity_to" do
    it "should return 0.0 when compared to nil" do
      n0 = Note.new(Pitch.new(50), Duration.new(1))
      n1 = Note.new(Pitch.new(52), Duration.new(2))
      b = Beat.new
      b.prev_note = n0
      b.cur_note  = n1

      b.similarity_to(nil).should be_within(0.01).of(0.0)
    end
    it "should return 0.0 when compared to a radically different duration" do
      n0 = Note.new(Pitch.new(50), Duration.new(2))
      n1 = Note.new(Pitch.new(52), Duration.new(1))
      b = Beat.new
      b.prev_note = n0
      b.cur_note  = n1

      n0 = Note.new(Pitch.new(100), Duration.new(2))
      n1 = Note.new(Pitch.new(10), Duration.new(20))
      b2 = Beat.new
      b2.prev_note = n0
      b2.cur_note  = n1

      b.similarity_to(b2).should be_within(0.01).of(0.0)
    end
    it "should return 1.0 when compared to itself" do
      n0 = Note.new(Pitch.new(50), Duration.new(1))
      n1 = Note.new(Pitch.new(50), Duration.new(1))
      b = Beat.new
      b.prev_note = n0
      b.cur_note  = n1

      b.similarity_to(b).should be_within(0.01).of(1.0)
    end
  end

end
