require 'thread'
require 'portmidi'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'midi'))

require 'rubymusic_midi'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require File.join(File.dirname(__FILE__), 'lib', 'pitch')
require File.join(File.dirname(__FILE__), 'lib', 'interval')
require File.join(File.dirname(__FILE__), 'lib', 'duration')
require File.join(File.dirname(__FILE__), 'lib', 'note')

require File.join(File.dirname(__FILE__), 'lib', 'meter')
require File.join(File.dirname(__FILE__), 'lib', 'beat_position')
require File.join(File.dirname(__FILE__), 'lib', 'duration_and_beat_position')

require File.join(File.dirname(__FILE__), 'lib', 'beat')
require File.join(File.dirname(__FILE__), 'lib', 'beat_similarity_matrix')

require File.join(File.dirname(__FILE__), 'lib', 'note_queue')
require File.join(File.dirname(__FILE__), 'lib', 'meter_detector')

require File.join(File.dirname(__FILE__), 'lib', 'duration_symbol')
require File.join(File.dirname(__FILE__), 'lib', 'interval_symbol')
require File.join(File.dirname(__FILE__), 'lib', 'pitch_symbol')
require File.join(File.dirname(__FILE__), 'lib', 'meter_symbol')
require File.join(File.dirname(__FILE__), 'lib', 'beat_position_symbol')
require File.join(File.dirname(__FILE__), 'lib', 'duration_and_beat_position_symbol')

