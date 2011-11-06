#!/usr/bin/env ruby

$LOAD_PATH.unshift "."

require 'rubygems'
require 'midi/device_layer'
require 'listen/listener'

module Observers

  class ResponseGenerator
  
    def initialize(machine, listener)
      @machine  = machine
      @listener = listener
  
      @machine.context.add_observer(self)
    end
  
    def update(event_queue)
      Thread.new do
        @listener.respond(event_queue)
        @machine.response_done
      end
    end
  
  end

  class InboundEventRouter
    def initialize(dev_layer, machine)
      dev_layer.add_observer(self)
      @machine = machine
    end
  
    def update(event)
      @machine.midievent(event)
    end
  end

  class ResponsePlayer
  
    def initialize(listener, device_layer)
      @device_layer = device_layer

      listener.add_observer(self)
    end
  
    def update(ev_queue)
      last_timestamp = ev_queue.first[:timestamp]
      ev_queue.each do |cur_event|
        if cur_event[:timestamp] > last_timestamp
          sleep (cur_event[:timestamp] - last_timestamp)
          last_timestamp = cur_event[:timestamp]
        end

        @device_layer.write(cur_event[:message])
      end

      puts "done."
      puts
    end

  end

end

class InteractiveImproviser

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
    
    @inbound_event_router = Observers::InboundEventRouter.new(@midi_device_layer, @machine)
	@response_generator   = Observers::ResponseGenerator.new(@machine, @listener)
    @response_player      = Observers::ResponsePlayer.new(@listener, @midi_device_layer)
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

