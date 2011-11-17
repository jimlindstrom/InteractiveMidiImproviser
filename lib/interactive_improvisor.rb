#!/usr/bin/env ruby

#require 'interactive_improvisor_lib'
require 'specs/vectors/fake_sensor_vectors'

class InteractiveImprovisor
  def initialize
    @improvisor = Improvisor.new

    @listener = Listener.new
    @improvisor.get_critics.each { |c| @listener.add_critic(c) }
  end

  def train
    @sensor = FakeSensor.new($fake_sensor_vectors)

    until (stimulus_events = @sensor.get_stimulus).nil?
      stimulus_notes = stimulus_events.to_note_queue
      @listener.listen stimulus_notes
    end
  end

  def run(use_real_midi=true)
    if use_real_midi
      clock      = Midi::Clock.new(0)
      @sensor    = MidiSensor.new("VMPK Output", clock)
      @sensor.set_stimulus_timeout(5.0)
      @performer = MidiPerformer.new("VMPK Input")
    else
      @sensor = FakeSensor.new($fake_sensor_vectors)
      @performer = FakePerformer.new
    end

    until (stimulus_events = @sensor.get_stimulus).nil?
      stimulus_notes = stimulus_events.to_note_queue

      @listener.listen stimulus_notes
      response_notes = @improvisor.generate

      response_notes.tempo = 400
      response_events = response_notes.to_event_queue
      @performer.perform response_events
    end

    @sensor.close if @sensor.class == MidiSensor
    @performer.close if @performer.class == MidiPerformer
  end
end
