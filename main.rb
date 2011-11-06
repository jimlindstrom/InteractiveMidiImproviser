#!/usr/bin/env ruby

$LOAD_PATH.unshift "."

require 'rubygems'
require 'midi/device_layer'
require 'listen/listener'

class InteractiveImproviser

  def initialize
  end

  def setup_devices
    begin
      in_port_vmpk       = Portmidi.input_devices.find{ |x| x.name=="VMPK Output"      }.device_id
      out_port_vmpk      = Portmidi.output_devices.find{|x| x.name=="VMPK Input"       }.device_id
    rescue NoMethodError
      puts "Please start VMPK (virtual midi piano keyboard)"
      exit
    end

    begin
      out_port_timidity0 = Portmidi.output_devices.find{|x| x.name=="TiMidity port 0"  }.device_id
    rescue NoMethodError
      puts "Please set up Timidity"
      exit
    end
    
    @midi_device_layer = Midi::DeviceLayer.new(in_port_vmpk, out_port_timidity0)
    @midi_device_layer.set_logging(true)
  end

  def setup_listener
    @listener = Listen::Listener.new
    @machine  = Listen::create_listener_machine
    
    @midi_event_router = Listen::MidiEventRouter.new(@midi_device_layer, @machine)
	@machine_observer  = Listen::MachineObserver.new(@machine, @listener)
    @listener_observer = Listen::ListenerObserver.new(@listener, @midi_device_layer)
  end

  def run
    @midi_device_layer.start
    gets
    @midi_device_layer.stop
  end

end


Thread.abort_on_exception = true

improviser = InteractiveImproviser.new
improviser.setup_devices
improviser.setup_listener
improviser.run

