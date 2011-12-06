#!/usr/bin/env ruby 

require 'spec_helper'
require 'ruby-prof'

describe InteractiveImprovisor do
  context ".get_single_improvisation" do
    before(:all) do
      @i = InteractiveImprovisor.new
      @i.train
    end
    it "should generate metrically-intelligable improvisations >70% of the time" do
      RubyProf.start
      3.times do
        nq = @i.get_single_improvisation
        nq.detect_meter
      end
      result = RubyProf.stop
      printer = RubyProf::FlatPrinter.new(result)
      printer.print(STDOUT, :min_percent => 0, :mode=>RubyProf::CPU_TIME)
    end
  end
end
