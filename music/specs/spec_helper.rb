# load the implementation
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))
require 'rubymusic_music'

# load any vectors
Dir[File.expand_path(File.join(File.dirname(__FILE__),'vectors','*.rb'))].each {|f| require f}

# load any shared examples
#Dir[File.expand_path(File.join(File.dirname(__FILE__),'shared','*.rb'))].each {|f| require f}
