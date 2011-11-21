#!/usr/bin/env ruby 

require 'spec_helper'

describe Meter do
  before do
  end

  context "new" do
    before(:each) do
      @beats_per_measure = 3 # 3/4 time
      @beat_unit         = 4
      @subdivs_per_beat  = 2 # expressed in eight notes
    end
    it "should take 3 values: beats/measure, a beat unit, and subdivisions/beat" do
      Meter.new(@beats_per_measure, @beat_unit, @subdivs_per_beat).should be_an_instance_of Meter
    end

    it "should take beats/measure of 2 through 12" do
      @beats_per_measure = 2 # 3/4 time
      Meter.new(@beats_per_measure, @beat_unit, @subdivs_per_beat).should be_an_instance_of Meter
    end
    it "should take beats/measure of 2 through 12" do
      @beats_per_measure = 12 # 12/4 time
      Meter.new(@beats_per_measure, @beat_unit, @subdivs_per_beat).should be_an_instance_of Meter
    end

    it "should take beat units of 2, 4, or 8" do
      @beat_unit = 2 # 3/2 time
      Meter.new(@beats_per_measure, @beat_unit, @subdivs_per_beat).should be_an_instance_of Meter
    end
    it "should take beat units of 2, 4, or 8" do
      @beat_unit = 4 # 3/4 time
      Meter.new(@beats_per_measure, @beat_unit, @subdivs_per_beat).should be_an_instance_of Meter
    end
    it "should take beat units of 2, 4, or 8" do
      @beat_unit = 8 # 3/8 time
      Meter.new(@beats_per_measure, @beat_unit, @subdivs_per_beat).should be_an_instance_of Meter
    end

    it "should take subdivs/beat of 1, 2, or 4" do
      @subdivs_per_beat = 1 # expressed in the beat unit
      Meter.new(@beats_per_measure, @beat_unit, @subdivs_per_beat).should be_an_instance_of Meter
    end
    it "should take subdivs/beat of 1, 2, or 4" do
      @subdivs_per_beat = 4 # expressed 4ths of the beat unit
      Meter.new(@beats_per_measure, @beat_unit, @subdivs_per_beat).should be_an_instance_of Meter
    end

    it "raise an error on invalid parameters" do
      lambdas = []
      lambdas.push lambda { Meter.new(1,                  @beat_unit, @subdivs_per_beat) }
      lambdas.push lambda { Meter.new(13,                 @beat_unit, @subdivs_per_beat) }
      lambdas.push lambda { Meter.new(@beats_per_measure, 1,          @subdivs_per_beat) }
      lambdas.push lambda { Meter.new(@beats_per_measure, 3,          @subdivs_per_beat) }
      lambdas.push lambda { Meter.new(@beats_per_measure, 5,          @subdivs_per_beat) }
      lambdas.push lambda { Meter.new(@beats_per_measure, 6,          @subdivs_per_beat) }
      lambdas.push lambda { Meter.new(@beats_per_measure, 7,          @subdivs_per_beat) }
      lambdas.push lambda { Meter.new(@beats_per_measure, 9,          @subdivs_per_beat) }
      lambdas.push lambda { Meter.new(@beats_per_measure, @beat_unit, 0                ) }
      lambdas.push lambda { Meter.new(@beats_per_measure, @beat_unit, 3                ) }
      lambdas.push lambda { Meter.new(@beats_per_measure, @beat_unit, 5                ) }
      lambdas.each do |l|
        expect { l.call }.to raise_error(ArgumentError)
      end
    end
  end

  context "num_values" do
    it "should return 99" do # Array(2..12).length * [2, 4, 8].length * [1, 2, 4].length
      Meter.num_values.should be 99
    end
  end

  context "to_symbol" do
    it "should return a MeterSymbol" do
      @beats_per_measure = 3 # 3/4 time
      @beat_unit         = 4
      @subdivs_per_beat  = 2 # expressed in eight notes
      m = Meter.new(@beats_per_measure, @beat_unit, @subdivs_per_beat)
      m.to_symbol.should be_an_instance_of MeterSymbol
    end
    it "should return a MeterSymbol whose value corresponds to the Meter's value" do
      @beats_per_measure = 2 # 3/4 time
      @beat_unit         = 2
      @subdivs_per_beat  = 1 # expressed in eight notes
      m = Meter.new(@beats_per_measure, @beat_unit, @subdivs_per_beat)
      m.to_symbol.val.should equal 0
    end
  end

  context "beats_per_measure" do
    it "should get the number of beats per measure" do
      @beats_per_measure = 2 # 3/4 time
      @beat_unit         = 2
      @subdivs_per_beat  = 1 # expressed in eight notes
      m = Meter.new(@beats_per_measure, @beat_unit, @subdivs_per_beat)
      m.beats_per_measure.should equal 2
    end
  end

  context "beat_unit" do
    it "should get beat unit" do
      @beats_per_measure = 2 # 3/4 time
      @beat_unit         = 2
      @subdivs_per_beat  = 1 # expressed in eight notes
      m = Meter.new(@beats_per_measure, @beat_unit, @subdivs_per_beat)
      m.beat_unit.should equal 2
    end
  end

  context "subdivs_per_beat" do
    it "should get number of subdivisions per beat" do
      @beats_per_measure = 2 # 3/4 time
      @beat_unit         = 2
      @subdivs_per_beat  = 1 # expressed in eight notes
      m = Meter.new(@beats_per_measure, @beat_unit, @subdivs_per_beat)
      m.subdivs_per_beat.should equal 1
    end
  end

  context "val" do
    it "should return all values" do
      @beats_per_measure = 2 # 3/4 time
      @beat_unit         = 2
      @subdivs_per_beat  = 1 # expressed in eight notes
      m = Meter.new(@beats_per_measure, @beat_unit, @subdivs_per_beat)
      m.val.should == {:beats_per_measure => 2, :beat_unit => 2, :subdivs_per_beat => 1}
    end
  end

end
