# midi_event_queue_spec.rb

require 'spec_helper'

describe Music::NoteQueue do

  before(:each) do
  end

  describe ".beat_array" do
    before(:each) do
      @nq = Music::NoteQueue.new
      @nq.tempo = 100
      @nq.push Music::Note.new(Music::Pitch.new(1), Music::Duration.new(1))
      @nq.push Music::Note.new(Music::Pitch.new(2), Music::Duration.new(4))
      @nq.push Music::Note.new(Music::Pitch.new(3), Music::Duration.new(2))
    end
    it "returns an array containing one element per beat" do
      @nq.beat_array.length.should == (1+4+2)
    end
    it "returns an array containing Beats where there are note onsets" do
      @nq.beat_array[0+1+4].should be_an_instance_of Music::Beat
    end
    it "returns an array containing Beats where there are rest onsets" do
      @nq.push Music::Rest.new(Music::Duration.new(2))
      @nq.beat_array[0+1+4+2].should be_an_instance_of Music::Beat
    end
    it "returns an array containing nils where there aren't note onsets" do
      @nq.beat_array[0+2].nil?.should be_true
    end
    
  end

  describe ".detect_meter" do
    context "when the note queue is metrically clear and only contains notes" do
      before(:each) do
        vector = $meter_vectors["Bring back my bonnie to me"]
        @nq = vector[:note_queue]
      end
      it "returns true" do
        @nq.detect_meter.should == true
      end
    end
    context "when the note queue is metrically ambiguous" do
      before(:each) do
        vector = $meter_vectors["Bring back my bonnie to me"]
        nq = vector[:note_queue]
        @nq = nq[0..0] # something so short it's guaranteed to be metrically ambiguous
      end
      it "returns false" do
        @nq.detect_meter.should == false
      end
    end
    context "when the note queue is metrically clear and contains notes and rests" do
      before(:each) do
        @nq = Music::NoteQueue.new
        @nq.tempo = 100
        5.times do
          @nq.push Music::Note.new(Music::Pitch.new(1), Music::Duration.new(3))
          @nq.push Music::Note.new(Music::Pitch.new(3), Music::Duration.new(2))
          @nq.push Music::Rest.new(                     Music::Duration.new(1))
        end
      end
      it "returns true" do
        @nq.detect_meter.should == true
      end
    end
    context "when run over all training vectors" do
      it "detects the meter of >85% the time" do
        successes     = []
        failures      = []
        num_successes = 0
        $meter_vectors.keys.sort.each do |key|
          vector = $meter_vectors[key]
          @nq = vector[:note_queue]
          if @nq.detect_meter
            if @nq.meter.val == vector[:meter].val
              if @nq.first.analysis[:beat_position].to_hash.inspect == vector[:first_beat_position].to_hash.inspect
                num_successes += 1
                successes.push "%-34s" % "\"#{key}\"" 
              else
                failures.push ("%-34s" % "\"#{key}\"" ) + 
                              "wrong initial beat   (" + 
                              @nq.first.analysis[:beat_position].to_hash.inspect.gsub(/:measure=>0, /, "") + " != " +
                              vector[:first_beat_position].to_hash.inspect.gsub(/:measure=>0, /, "") + ")"
              end
            else
              calced_subbeats_per_measure =  @nq.meter.beats_per_measure * @nq.meter.subbeats_per_beat
              actual_subbeats_per_measure =  vector[:meter].beats_per_measure * vector[:meter].subbeats_per_beat
              error_direction = calced_subbeats_per_measure > actual_subbeats_per_measure ? ">" : "<"
              failures.push ("%-34s" % "\"#{key}\"" ) + 
                            "wrong time signature (" + 
                            @nq.meter.val.inspect.gsub(/, :beat_unit=>4/, "").gsub(/_per[A-Za-z_]*/, '') + 
                            " #{error_direction} " +
                            vector[:meter].val.inspect.gsub(/, :beat_unit=>4/, "").gsub(/_per[A-Za-z_]*/, '') + ")"
            end
          else
            failures.push "\"#{key}\": failed to find a meter"
          end
        end
  
        if failures.length > 0
          puts "\tsuccesses:"
          puts "\t\t" + successes.join("\n\t\t")
          puts 
          puts "\tfailures:"
          puts "\t\t" + failures.join("\n\t\t")
        end
  
        success_rate = num_successes.to_f / $meter_vectors.keys.length
        success_rate.should be >= 0.85
      end
    end
  end

end
