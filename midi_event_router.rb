#!/usr/bin/env ruby

require 'observer'

class MidiEventRouter
  def initialize(dev_layer, machine)
    dev_layer.add_observer(self)
    @machine = machine
  end

  def update(event)
    @machine.midievent(event)
  end
end

