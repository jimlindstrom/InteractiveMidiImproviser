require 'thread'
require 'portmidi'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require File.join(File.dirname(__FILE__), 'lib', 'event')
require File.join(File.dirname(__FILE__), 'lib', 'ioi_array')
require File.join(File.dirname(__FILE__), 'lib', 'event_queue')
require File.join(File.dirname(__FILE__), 'lib', 'clock')
require File.join(File.dirname(__FILE__), 'lib', 'loopback')
require File.join(File.dirname(__FILE__), 'lib', 'in_port')
require File.join(File.dirname(__FILE__), 'lib', 'out_port')

