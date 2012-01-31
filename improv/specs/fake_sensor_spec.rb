#!/usr/bin/env ruby 

require 'spec_helper'

describe FakeSensor do

  it_should_behave_like "a sensor", FakeSensor.new($fake_sensor_vectors, expected_num_responses=5), expected_num_responses=4

end

