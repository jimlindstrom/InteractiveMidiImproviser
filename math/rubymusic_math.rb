require 'thread'
require 'portmidi'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require File.join(File.dirname(__FILE__), 'lib', 'random_variable')
require File.join(File.dirname(__FILE__), 'lib', 'markov_chain')
require File.join(File.dirname(__FILE__), 'lib', 'bidirectional_markov_chain')
require File.join(File.dirname(__FILE__), 'lib', 'asymmetric_markov_chain')
