#!/usr/bin/env ruby 

require 'spec_helper'

describe Music::Meter do
  before do
  end

  context "new" do
    before(:each) do
      @beats_per_measure = 3 # 3/4 time
      @beat_unit         = 4
      @subdivs_per_beat  = 2 # expressed in eight notes
    end
    it "should take 3 values: beats/measure, a beat unit, and subdivisions/beat" do
      Music::Meter.new(@beats_per_measure, @beat_unit, @subdivs_per_beat).should be_an_instance_of Music::Meter
    end

    it "should take beats/measure of 2 through 6" do
      @beats_per_measure = 2 # 3/4 time
      Music::Meter.new(@beats_per_measure, @beat_unit, @subdivs_per_beat).should be_an_instance_of Music::Meter
    end
    it "should take beats/measure of 2 through 6" do
      @beats_per_measure = 6 # 6/4 time
      Music::Meter.new(@beats_per_measure, @beat_unit, @subdivs_per_beat).should be_an_instance_of Music::Meter
    end

    it "should take beat units of 2, 4, or 8" do
      @beat_unit = 2 # 3/2 time
      Music::Meter.new(@beats_per_measure, @beat_unit, @subdivs_per_beat).should be_an_instance_of Music::Meter
    end
    it "should take beat units of 2, 4, or 8" do
      @beat_unit = 4 # 3/4 time
      Music::Meter.new(@beats_per_measure, @beat_unit, @subdivs_per_beat).should be_an_instance_of Music::Meter
    end
    it "should take beat units of 2, 4, or 8" do
      @beat_unit = 8 # 3/8 time
      Music::Meter.new(@beats_per_measure, @beat_unit, @subdivs_per_beat).should be_an_instance_of Music::Meter
    end

    it "should take subdivs/beat of 1, 2, or 4" do
      @subdivs_per_beat = 1 # expressed in the beat unit
      Music::Meter.new(@beats_per_measure, @beat_unit, @subdivs_per_beat).should be_an_instance_of Music::Meter
    end
    it "should take subdivs/beat of 1, 2, or 4" do
      @subdivs_per_beat = 4 # expressed 4ths of the beat unit
      Music::Meter.new(@beats_per_measure, @beat_unit, @subdivs_per_beat).should be_an_instance_of Music::Meter
    end

    it "raise an error on invalid parameters" do
      lambdas = []
      lambdas.push lambda { Music::Meter.new(1,                  @beat_unit, @subdivs_per_beat) }
      lambdas.push lambda { Music::Meter.new(7,                  @beat_unit, @subdivs_per_beat) }
      lambdas.push lambda { Music::Meter.new(@beats_per_measure, 1,          @subdivs_per_beat) }
      lambdas.push lambda { Music::Meter.new(@beats_per_measure, 3,          @subdivs_per_beat) }
      lambdas.push lambda { Music::Meter.new(@beats_per_measure, 5,          @subdivs_per_beat) }
      lambdas.push lambda { Music::Meter.new(@beats_per_measure, 6,          @subdivs_per_beat) }
      lambdas.push lambda { Music::Meter.new(@beats_per_measure, 7,          @subdivs_per_beat) }
      lambdas.push lambda { Music::Meter.new(@beats_per_measure, 9,          @subdivs_per_beat) }
      lambdas.push lambda { Music::Meter.new(@beats_per_measure, @beat_unit, 0                ) }
      lambdas.push lambda { Music::Meter.new(@beats_per_measure, @beat_unit, 3                ) }
      lambdas.push lambda { Music::Meter.new(@beats_per_measure, @beat_unit, 5                ) }
      lambdas.each do |l|
        expect { l.call }.to raise_error(ArgumentError)
      end
    end
  end

  context "num_values" do
    it "should return 45" do # Array(2..6).length * [2, 4, 8].length * [1, 2, 4].length
      Music::Meter.num_values.should == 45
    end
  end

  context "random" do
    it "should return a Meter" do
      Music::Meter.random.should be_an_instance_of Music::Meter
    end
  end

  context "initial_beat_position" do
    it "should return a BeatPosition corresponding to the first beat in that meter" do
      m = Music::Meter.random
      m.initial_beat_position.should be_an_instance_of Music::BeatPosition
    end
  end

  context "beats_per_measure" do
    it "should get the number of beats per measure" do
      @beats_per_measure = 2 # 3/4 time
      @beat_unit         = 2
      @subdivs_per_beat  = 1 # expressed in eight notes
      m = Music::Meter.new(@beats_per_measure, @beat_unit, @subdivs_per_beat)
      m.beats_per_measure.should equal 2
    end
  end

  context "beat_unit" do
    it "should get beat unit" do
      @beats_per_measure = 2 # 3/4 time
      @beat_unit         = 2
      @subdivs_per_beat  = 1 # expressed in eight notes
      m = Music::Meter.new(@beats_per_measure, @beat_unit, @subdivs_per_beat)
      m.beat_unit.should equal 2
    end
  end

  context "subdivs_per_beat" do
    it "should get number of subdivisions per beat" do
      @beats_per_measure = 2 # 3/4 time
      @beat_unit         = 2
      @subdivs_per_beat  = 1 # expressed in eight notes
      m = Music::Meter.new(@beats_per_measure, @beat_unit, @subdivs_per_beat)
      m.subdivs_per_beat.should equal 1
    end
  end

  context "val" do
    it "should return all values" do
      @beats_per_measure = 2 # 3/4 time
      @beat_unit         = 2
      @subdivs_per_beat  = 1 # expressed in eight notes
      m = Music::Meter.new(@beats_per_measure, @beat_unit, @subdivs_per_beat)
      m.val.should == {:beats_per_measure => 2, :beat_unit => 2, :subdivs_per_beat => 1}
    end
  end

end
