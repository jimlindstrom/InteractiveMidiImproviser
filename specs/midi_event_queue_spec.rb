# midi_event_queue_spec.rb

require 'spec_helper'

describe Midi::EventQueue do

  before(:all) do
    @test_events = [
      Midi::Event.new({:message   => Midi::Event::NOTE_ON,
                       :pitch     => 40,
                       :velocity  => 100,
                       :timestamp => 1000 }),
      Midi::Event.new({:message   => Midi::Event::NOTE_OFF,
                       :pitch     => 40,
                       :velocity  => 100,
                       :timestamp => 2000 }),

      Midi::Event.new({:message   => Midi::Event::NOTE_ON,
                       :pitch     => 42,
                       :velocity  => 100,
                       :timestamp => 2000 }),
      Midi::Event.new({:message   => Midi::Event::NOTE_OFF,
                       :pitch     => 42,
                       :velocity  => 100,
                       :timestamp => 3000 }),

      Midi::Event.new({:message   => Midi::Event::NOTE_ON,
                       :pitch     => 44,
                       :velocity  => 100,
                       :timestamp => 3000 }),
      Midi::Event.new({:message   => Midi::Event::NOTE_OFF,
                       :pitch     => 44,
                       :velocity  => 100,
                       :timestamp => 4000 }) ]

  end

  before(:each) do
  end
     
  describe ".enqueue" do
    it "raises an error if the new element is not a Midi::Event" do
      @evq = Midi::EventQueue.new
      expect { @evq.enqueue({:message=>[Midi::Event::NOTE_ON,40,100,0],:timestamp=>1000}) }.to raise_error(ArgumentError)
    end
  end
   
  describe ".length" do
    it "returns zero initially" do
      @evq = Midi::EventQueue.new
      @evq.length.should == 0
    end

    it "returns the number of events enqueued" do
      @evq = Midi::EventQueue.new
      @num_events=(rand*50).round
      @num_events.times do 
        @evq.enqueue(Midi::Event.new({:message   => Midi::Event::NOTE_ON,
                                      :pitch     => 40,
                                      :velocity  => 100,
                                      :timestamp => 1000 }))

      end
      @evq.length.should == @num_events
    end
  end

  describe ".clear" do
    it "dumps the queued events" do
      @evq = Midi::EventQueue.new
      @num_events=(rand*50).round
      @num_events.times do 
        @evq.enqueue(Midi::Event.new({:message   => Midi::Event::NOTE_ON,
                                      :pitch     => 40,
                                      :velocity  => 100,
                                      :timestamp => 1000 }))
      end
      @evq.clear
      @evq.enqueue(Midi::Event.new({:message   => Midi::Event::NOTE_ON,
                                    :pitch     => 40,
                                    :velocity  => 100,
                                    :timestamp => 1000 }))
      @evq.length.should == 1
    end
  end

  describe ".to_note_queue" do
    before (:each) do
      @evq = Midi::EventQueue.new
      @test_events.each { |e| @evq.enqueue e }
      @nq = @evq.to_note_queue
    end

    it "returns a NoteQueue" do
      @nq.class.should == NoteQueue
    end
    it "converts the event queue into notes with the correct pitches" do
      @nq.map { |x| x.pitch.val }.should == [40, 42, 44]
    end
    it "converts the event queue into notes with the correct quantized duration" do
      @nq.map { |x| x.duration.val }.should == [1, 1, 1]
    end
    it "calculates tempo" do
      @nq.tempo.should == 1000
    end
  end

end
