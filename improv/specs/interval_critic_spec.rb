#!/usr/bin/env ruby 

require 'spec_helper'

describe IntervalCritic do
  before do
  end

  context ".new" do
    it "should return a IntervalCritic" do
      IntervalCritic.new(order=2, lookahead=1).should be_an_instance_of IntervalCritic
    end
  end

  context ".reset" do
    it "should reset to the state in which no notes have been heard yet" do
      ic = IntervalCritic.new(order=2, lookahead=1)

      base_note = (rand*50).floor + 25
      interval = (rand*20).floor - 10

      note = Music::Note.new(Music::Pitch.new(base_note), Music::Duration.new(1))
      note.analysis[:notes_left] = 2
      ic.listen note

      note = Music::Note.new(Music::Pitch.new(base_note + interval), Music::Duration.new(1))
      note.analysis[:notes_left] = 1
      ic.listen note

      ic.reset

      base_note = (rand*50).floor + 25

      note = Music::Note.new(Music::Pitch.new(base_note), Music::Duration.new(1))
      note.analysis[:notes_left] = 2
      ic.listen note

      x = ic.get_expectations
      Music::Pitch.new(x.choose_outcome).val.should == (base_note + interval)
    end
  end

  context ".save" do
    it "should save a file, named <folder>/interval_critic_<order>_<lookahead>.yml" do
      ic = IntervalCritic.new(order=2, lookahead=1)

      note = Music::Note.new(Music::Pitch.new(4), Music::Duration.new(1))
      note.analysis[:notes_left] = 5
      ic.listen note

      note = Music::Note.new(Music::Pitch.new(4), Music::Duration.new(1))
      note.analysis[:notes_left] = 4
      ic.listen note

      note = Music::Note.new(Music::Pitch.new(4), Music::Duration.new(1))
      note.analysis[:notes_left] = 3
      ic.listen note

      note = Music::Note.new(Music::Pitch.new(2), Music::Duration.new(1))
      note.analysis[:notes_left] = 2
      ic.listen note

      filename = "data/test/interval_critic_#{order}_#{lookahead}.yml"
      File.delete filename if FileTest.exists? filename
      ic.save "data/test"
      FileTest.exists?(filename).should == true
    end
  end

  context ".load" do
    it "should load a file, named <folder>/interval_critic_<order>_<lookahead>.yml, and act just like the saved critic" do
      ic = IntervalCritic.new(order=2, lookahead=1)

      note = Music::Note.new(Music::Pitch.new(1), Music::Duration.new(1))
      note.analysis[:notes_left] = 5
      ic.listen note

      note = Music::Note.new(Music::Pitch.new(9), Music::Duration.new(1))
      note.analysis[:notes_left] = 4
      ic.listen note

      note = Music::Note.new(Music::Pitch.new(3), Music::Duration.new(1))
      note.analysis[:notes_left] = 3
      ic.listen note

      note = Music::Note.new(Music::Pitch.new(5), Music::Duration.new(1))
      note.analysis[:notes_left] = 2
      ic.listen note

      ic.reset

      note = Music::Note.new(Music::Pitch.new(1), Music::Duration.new(1))
      note.analysis[:notes_left] = 5
      ic.listen note

      note = Music::Note.new(Music::Pitch.new(9), Music::Duration.new(1))
      note.analysis[:notes_left] = 4
      ic.listen note

      note = Music::Note.new(Music::Pitch.new(3), Music::Duration.new(1))
      note.analysis[:notes_left] = 3
      ic.listen note

      ic.save "data/test"
      ic2 = IntervalCritic.new(order, lookahead=1)
      ic2.load "data/test"
      10.times do # it's probabalistic, so let's try it a few times
        x = ic.get_expectations
        x2 = ic2.get_expectations
        x.choose_outcome.should == x2.choose_outcome
      end
    end
  end

  context ".cumulative_information_content" do
    it "should return zero initially" do
      ic = IntervalCritic.new(order=2, lookahead=1)
      ic.cumulative_information_content.should be_within(0.0001).of(0.0)
    end
    it "should return the sum of all listening information_content" do
      ic = IntervalCritic.new(order=2, lookahead=1)

      notes  = [ Music::Note.new(Music::Pitch.new(1), Music::Duration.new(1)) ]
      notes.push Music::Note.new(Music::Pitch.new(2), Music::Duration.new(1))
      notes.push Music::Note.new(Music::Pitch.new(1), Music::Duration.new(1))
      notes.push Music::Note.new(Music::Pitch.new(6), Music::Duration.new(1))

      cum_information_content = 0.0
      notes_left = 6
      notes.each do |note|
        note.analysis[:notes_left] = (notes_left -= 1)
        cum_information_content += ic.information_content(note) || 0.0
        ic.listen(note)
      end

      ic.cumulative_information_content.should be_within(0.0001).of(cum_information_content)
    end
    it "should return zero after calling reset_cumulative_information_content" do
      ic = IntervalCritic.new(order=2, lookahead=1)

      note = Music::Note.new(Music::Pitch.new(1), Music::Duration.new(1))
      note.analysis[:notes_left] = 4
      dummy = ic.information_content(note)
      ic.listen(note)

      note = Music::Note.new(Music::Pitch.new(6), Music::Duration.new(1))
      note.analysis[:notes_left] = 3
      dummy = ic.information_content(note)
      ic.listen(note)

      ic.reset_cumulative_information_content
      ic.cumulative_information_content.should be_within(0.0001).of(0.0)
    end
  end

  context ".listen" do
    it "should raise an error if the note analysis does not contain notes_left" do
      ic = IntervalCritic.new(order=2, lookahead=1)
      expect { ic.listen(Music::Note.new(Music::Pitch.new(1), Music::Duration.new(0))) }.to raise_error
    end
  end

  context ".information_content" do
    it "should raise an error if the note analysis does not contain notes_left" do
      ic = IntervalCritic.new(order=2, lookahead=1)
      expect { ic.information_content(Music::Note.new(Music::Pitch.new(1), Music::Duration.new(0))) }.to raise_error
    end
    it "should return nil, if zero notes have been heard" do
      ic = IntervalCritic.new(order=2, lookahead=1)

      note = Music::Note.new(Music::Pitch.new(6), Music::Duration.new(1))
      note.analysis[:notes_left] = 3
      ic.information_content(note).should be_nil
    end
    it "should return the information_content associated with the given note, if 1 or more notes have been heard" do
      ic = IntervalCritic.new(order=2, lookahead=1)

      note = Music::Note.new(Music::Pitch.new(6), Music::Duration.new(1))
      note.analysis[:notes_left] = 3
      ic.information_content(note)
      ic.listen(note)

      note = Music::Note.new(Music::Pitch.new(9), Music::Duration.new(1))
      note.analysis[:notes_left] = 2
      ic.information_content(note).should be_within(0.001).of(Math::RandomVariable.max_information_content)
    end
  end

  context ".get_expectations" do
    it "returns nil until one note has been listened to" do
      ic = IntervalCritic.new(order=2, lookahead=1)
      ic.get_expectations.should be_nil
    end
    it "returns a random variable" do
      ic = IntervalCritic.new(order=2, lookahead=1)

      note = Music::Note.new(Music::Pitch.new(6), Music::Duration.new(1))
      note.analysis[:notes_left] = 3
      ic.listen(note)

      ic.get_expectations.should be_an_instance_of Math::RandomVariable
    end
    it "returns a random variable that is less information_contentd about states observed more often" do
      ic = IntervalCritic.new(order=2, lookahead=1)

      note = Music::Note.new(Music::Pitch.new(0), Music::Duration.new(1))
      note.analysis[:notes_left] = 3
      dummy = ic.information_content(note)
      ic.listen(note)

      note = Music::Note.new(Music::Pitch.new(1), Music::Duration.new(1))
      note.analysis[:notes_left] = 2
      dummy = ic.information_content(note)
      ic.listen(note)

      ic.reset

      note = Music::Note.new(Music::Pitch.new(0), Music::Duration.new(1))
      note.analysis[:notes_left] = 3
      dummy = ic.information_content(note)
      ic.listen(note)

      note = Music::Note.new(Music::Pitch.new(1), Music::Duration.new(1))
      note.analysis[:notes_left] = 2
      dummy = ic.information_content(note)
      ic.listen(note)

      ic.reset

      note = Music::Note.new(Music::Pitch.new(0), Music::Duration.new(1))
      note.analysis[:notes_left] = 3
      dummy = ic.information_content(note)
      ic.listen(note)

      note = Music::Note.new(Music::Pitch.new(0), Music::Duration.new(1))
      note.analysis[:notes_left] = 2
      dummy = ic.information_content(note)
      ic.listen(note)

      ic.reset

      note = Music::Note.new(Music::Pitch.new(0), Music::Duration.new(1))
      note.analysis[:notes_left] = 3
      dummy = ic.information_content(note)
      ic.listen(note)

      x = ic.get_expectations
      x.information_content(Music::Pitch.new(1).val).should be < x.information_content(Music::Pitch.new(0).val)
    end
    it "returns a random variable that only chooses states observed" do
      ic = IntervalCritic.new(order=2, lookahead=1)

      base_note = (rand*50).floor + 25
      interval  = (rand*10).floor - 5

      note = Music::Note.new(Music::Pitch.new(base_note), Music::Duration.new(1))
      note.analysis[:notes_left] = 3
      dummy = ic.information_content(note)
      ic.listen(note)

      note = Music::Note.new(Music::Pitch.new(base_note + interval), Music::Duration.new(1))
      note.analysis[:notes_left] = 2
      dummy = ic.information_content(note)
      ic.listen(note)

      ic.reset

      base_note = (rand*50).floor + 25

      note = Music::Note.new(Music::Pitch.new(base_note), Music::Duration.new(1))
      note.analysis[:notes_left] = 3
      dummy = ic.information_content(note)
      ic.listen(note)

      x = ic.get_expectations
      Music::Pitch.new(x.choose_outcome).val.should == (base_note + interval)
    end
    it "returns a random variable that only chooses states observed (higher order)" do
      ic = IntervalCritic.new(order=3, lookahead=1)

      note = Music::Note.new(Music::Pitch.new(0), Music::Duration.new(1))
      note.analysis[:notes_left] = 8
      dummy = ic.information_content(note)
      ic.listen(note)

      note = Music::Note.new(Music::Pitch.new(1), Music::Duration.new(1)) # 1
      note.analysis[:notes_left] = 7
      dummy = ic.information_content(note)
      ic.listen(note)

      note = Music::Note.new(Music::Pitch.new(2), Music::Duration.new(1)) # 1
      note.analysis[:notes_left] = 6
      dummy = ic.information_content(note)
      ic.listen(note)

      note = Music::Note.new(Music::Pitch.new(3), Music::Duration.new(1)) # 1
      note.analysis[:notes_left] = 5
      dummy = ic.information_content(note)
      ic.listen(note)

      note = Music::Note.new(Music::Pitch.new(6), Music::Duration.new(1)) # 3
      note.analysis[:notes_left] = 4
      dummy = ic.information_content(note)
      ic.listen(note)

      ic.reset

      note = Music::Note.new(Music::Pitch.new(0), Music::Duration.new(1))
      note.analysis[:notes_left] = 8
      dummy = ic.information_content(note)
      ic.listen(note)

      note = Music::Note.new(Music::Pitch.new(5), Music::Duration.new(1)) # 5
      note.analysis[:notes_left] = 7
      dummy = ic.information_content(note)
      ic.listen(note)

      note = Music::Note.new(Music::Pitch.new(6), Music::Duration.new(1)) # 1
      note.analysis[:notes_left] = 6
      dummy = ic.information_content(note)
      ic.listen(note)

      note = Music::Note.new(Music::Pitch.new(7), Music::Duration.new(1)) # 1
      note.analysis[:notes_left] = 5
      dummy = ic.information_content(note)
      ic.listen(note)

      note = Music::Note.new(Music::Pitch.new(8), Music::Duration.new(1)) # 1
      note.analysis[:notes_left] = 4
      dummy = ic.information_content(note)
      ic.listen(note)

      ic.reset

      note = Music::Note.new(Music::Pitch.new(0), Music::Duration.new(1))
      note.analysis[:notes_left] = 8
      dummy = ic.information_content(note)
      ic.listen(note)

      note = Music::Note.new(Music::Pitch.new(5), Music::Duration.new(1)) # 5
      note.analysis[:notes_left] = 7
      dummy = ic.information_content(note)
      ic.listen(note)

      note = Music::Note.new(Music::Pitch.new(6), Music::Duration.new(1)) # 1
      note.analysis[:notes_left] = 6
      dummy = ic.information_content(note)
      ic.listen(note)

      note = Music::Note.new(Music::Pitch.new(7), Music::Duration.new(1)) # 1
      note.analysis[:notes_left] = 5
      dummy = ic.information_content(note)
      ic.listen(note)

      10.times do # it's probabalistic, so let's try it a few times
        x = ic.get_expectations
        last_note = 7
        expected_interval = 1
        Music::Pitch.new(x.choose_outcome).val.should == (last_note + expected_interval)
      end
    end
  end


end
