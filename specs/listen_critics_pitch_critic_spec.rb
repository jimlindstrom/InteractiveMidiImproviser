# listen_critics_pitch_critic_spec.rb

require 'listen/critics/pitch_critic'

describe Listen::Critics::PitchCritic do

  before :each do
    @critic = Listen::Critics::PitchCritic.new
  end

  it_should_behave_like "a critic"

end

