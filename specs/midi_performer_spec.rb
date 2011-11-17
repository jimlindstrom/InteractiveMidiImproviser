#!/usr/bin/env ruby 

require 'spec_helper'

describe MidiPerformer do
  before(:each) do
    Midi::Loopback.create

    @performer   = MidiPerformer.new("VirMIDI 1-0")

    @event_queue = Midi::EventQueue.new
    vector = $fake_sensor_vectors["mary had a little lamb (phrase 1)"]
    vector[:events].each do |e|
      @event_queue.enqueue e
    end
  end

  after(:each) do
    @performer.close

    Midi::Loopback.destroy
  end

  it_should_behave_like "a performer"
end
