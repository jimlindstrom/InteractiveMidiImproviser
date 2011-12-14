#!/usr/bin/env ruby 

require 'spec_helper'

describe FakeSensor do

  before :each do
    @sensor = FakeSensor.new($fake_sensor_vectors)
    @expected_num_responses = 5
  end

  it_should_behave_like "a sensor"
end

