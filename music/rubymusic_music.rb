require 'thread'
require 'portmidi'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'midi'))

require 'rubymusic_midi'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'math'))

require 'rubymusic_math'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require File.join(File.dirname(__FILE__), 'lib', 'pitch')
require File.join(File.dirname(__FILE__), 'lib', 'interval')
require File.join(File.dirname(__FILE__), 'lib', 'duration')
require File.join(File.dirname(__FILE__), 'lib', 'note')

require File.join(File.dirname(__FILE__), 'lib', 'meter')
require File.join(File.dirname(__FILE__), 'lib', 'beat_position')
require File.join(File.dirname(__FILE__), 'lib', 'duration_and_beat_position')

require File.join(File.dirname(__FILE__), 'lib', 'beat')
require File.join(File.dirname(__FILE__), 'lib', 'beat_cross_similarity_matrix')
require File.join(File.dirname(__FILE__), 'lib', 'beat_similarity_matrix')

require File.join(File.dirname(__FILE__), 'lib', 'pitch_class')
require File.join(File.dirname(__FILE__), 'lib', 'pitch_class_set')
require File.join(File.dirname(__FILE__), 'lib', 'weighted_pitch_class_set')

require File.join(File.dirname(__FILE__), 'lib', 'note_queue_meter_detection')

require File.join(File.dirname(__FILE__), 'lib', 'phrase_detection', 'lbdm_interval')
require File.join(File.dirname(__FILE__), 'lib', 'phrase_detection', 'dist_interval')
require File.join(File.dirname(__FILE__), 'lib', 'phrase_detection', 'note_queue_phrase_candidates')
require File.join(File.dirname(__FILE__), 'lib', 'phrase_detection', 'note_queue_phrases')
require File.join(File.dirname(__FILE__), 'lib', 'phrase_detection', 'phrase')
require File.join(File.dirname(__FILE__), 'lib', 'phrase_detection', 'phrase_list')

require File.join(File.dirname(__FILE__), 'lib', 'note_queue')

