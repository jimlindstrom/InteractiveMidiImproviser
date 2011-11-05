#!/usr/bin/env ruby

$LOAD_PATH.unshift "."

require 'rubygems'
require 'midi/device_layer'
require 'listen/listener'

IN_PORT_VMPK       = 6
OUT_PORT_VMPK      = 7
OUT_PORT_TIMIDITY0 = 2

Thread.abort_on_exception = true

# create things
$midi_device_layer = Midi::DeviceLayer.new(IN_PORT_VMPK, OUT_PORT_TIMIDITY0)
$listener = Listen::Listener.new

# wire thingsup
$listener.set_device_layer($midi_device_layer)
$midi_device_layer.set_event_callback( lambda { |event| $listener.machine.midievent(event) } )
$midi_device_layer.set_logging(true)

# run it
$midi_device_layer.start
gets
$midi_device_layer.stop
