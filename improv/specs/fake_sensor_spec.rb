#!/usr/bin/env ruby 

require 'spec_helper'

describe FakeSensor do

  before :each do
    @expected_num_responses = 5
    @sensor = FakeSensor.new($fake_sensor_vectors, @expected_num_responses)
  end

  it_should_behave_like "a sensor"
end

