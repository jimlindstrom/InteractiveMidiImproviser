require 'thread'
require 'portmidi'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require File.join(File.dirname(__FILE__), 'lib', 'midi', 'event')
require File.join(File.dirname(__FILE__), 'lib', 'midi', 'ioi_array')
require File.join(File.dirname(__FILE__), 'lib', 'midi', 'event_queue')
require File.join(File.dirname(__FILE__), 'lib', 'midi', 'clock')
require File.join(File.dirname(__FILE__), 'lib', 'midi', 'loopback')
require File.join(File.dirname(__FILE__), 'lib', 'midi', 'in_port')
require File.join(File.dirname(__FILE__), 'lib', 'midi', 'out_port')

require File.join(File.dirname(__FILE__), 'lib', 'pitch')
require File.join(File.dirname(__FILE__), 'lib', 'interval')
require File.join(File.dirname(__FILE__), 'lib', 'duration')
require File.join(File.dirname(__FILE__), 'lib', 'note')

require File.join(File.dirname(__FILE__), 'lib', 'note_queue')

require File.join(File.dirname(__FILE__), 'lib', 'duration_symbol')
require File.join(File.dirname(__FILE__), 'lib', 'interval_symbol')
require File.join(File.dirname(__FILE__), 'lib', 'pitch_symbol')

require File.join(File.dirname(__FILE__), 'lib', 'random_variable')
require File.join(File.dirname(__FILE__), 'lib', 'markov_chain')

require File.join(File.dirname(__FILE__), 'lib', 'critic')
require File.join(File.dirname(__FILE__), 'lib', 'duration_critic')
require File.join(File.dirname(__FILE__), 'lib', 'pitch_critic')
require File.join(File.dirname(__FILE__), 'lib', 'interval_critic')

require File.join(File.dirname(__FILE__), 'lib', 'duration_generator')
require File.join(File.dirname(__FILE__), 'lib', 'pitch_generator')

require File.join(File.dirname(__FILE__), 'lib', 'listener')
require File.join(File.dirname(__FILE__), 'lib', 'improvisor')
require File.join(File.dirname(__FILE__), 'lib', 'note_generator')

require File.join(File.dirname(__FILE__), 'lib', 'sensor')
require File.join(File.dirname(__FILE__), 'lib', 'fake_sensor')
require File.join(File.dirname(__FILE__), 'lib', 'midi_sensor')

require File.join(File.dirname(__FILE__), 'lib', 'fake_performer')

require File.join(File.dirname(__FILE__), 'lib', 'interactive_improvisor')
