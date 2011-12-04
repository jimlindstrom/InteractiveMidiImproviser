#!/usr/bin/env ruby

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
      if stimulus_notes.detect_meter # FIXME: feels like this should be in a critic...
        @listener.listen stimulus_notes # FIXME: figure out a way to listen with only partial info (no meter)
      end
    end
  end

  def get_single_improvisation
    @improvisor.generate
  end

  def run(use_real_midi=true)
    setup(use_real_midi)

    until (stimulus_events = @sensor.get_stimulus).nil?
      stimulus_notes = stimulus_events.to_note_queue

      if stimulus_notes.detect_meter # FIXME: feels like this should be in a critic
        puts "meter: #{stimulus_notes.meter.inspect}"
        @listener.listen stimulus_notes
      else
        puts "failed to detect meter. ignoring stimulus."
      end

      response_notes = @improvisor.generate

      response_notes.tempo = 400
      response_events = response_notes.to_event_queue
      @performer.perform response_events
    end

    teardown
  end

  private

  def setup(use_real_midi=true)
    if use_real_midi
      clock      = Midi::Clock.new(0)
      @sensor    = MidiSensor.new("VMPK Output", clock)
      @sensor.set_stimulus_timeout(5.0)
      #@performer = MidiPerformer.new("VMPK Input")
      @performer = MidiPerformer.new("TiMidity port 0")
    else
      @sensor = FakeSensor.new($fake_sensor_vectors)
      @performer = FakePerformer.new
    end
  end

  def teardown
    @sensor.close if @sensor.class == MidiSensor
    @performer.close if @performer.class == MidiPerformer
  end
  
end
