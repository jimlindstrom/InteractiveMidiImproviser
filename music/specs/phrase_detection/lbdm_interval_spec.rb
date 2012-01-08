#!/usr/bin/env ruby 

require 'spec_helper'

describe Music::LBDMInterval do
  before do
  end

  context "new" do
    it "should take two notes" do
      n1 = Music::Note.new(Music::Pitch.new(60), Music::Duration.new(1))
      n2 = Music::Note.new(Music::Pitch.new(62), Music::Duration.new(2))

      Music::LBDMInterval.new(n1, n2).should be_an_instance_of Music::LBDMInterval
    end
  end

  context "x" do
    before(:all) do
      @n1 = Music::Note.new(Music::Pitch.new(60), Music::Duration.new( 1))
      @n2 = Music::Note.new(Music::Pitch.new(90), Music::Duration.new(10))
    end
    it "should return 0.5 for identical notes" do
      Music::LBDMInterval.new(@n1, @n1).x.should be_within(0.001).of(0.5)
    end
    it "should return 1.0 when the second note is significantly higher or longer" do
      Music::LBDMInterval.new(@n1, @n2).x.should be_within(0.001).of(1.0)
    end
    it "should return 0.0 when the second note is significantly lower or shorter" do
      Music::LBDMInterval.new(@n2, @n1).x.should be_within(0.001).of(0.0)
    end
  end

  context "r_before" do
    it "should be 0.0 if you haven't set the previous interval" do
      @n0 = Music::Note.new(Music::Pitch.new(20), Music::Duration.new( 2))
      @n1 = Music::Note.new(Music::Pitch.new(20), Music::Duration.new( 2))
      @n2 = Music::Note.new(Music::Pitch.new(20), Music::Duration.new( 2))

      @i01 = Music::LBDMInterval.new(@n0, @n1)
      @i12 = Music::LBDMInterval.new(@n1, @n2)

      @i01.next_interval = @i12
      @i12.prev_interval = @i01

      @i01.r_before.should be_within(0.001).of(0.0)
    end
    it "should return 0.0 if the interval is the same as the one before it" do
      @n0 = Music::Note.new(Music::Pitch.new(20), Music::Duration.new( 2))
      @n1 = Music::Note.new(Music::Pitch.new(22), Music::Duration.new( 2))
      @n2 = Music::Note.new(Music::Pitch.new(24), Music::Duration.new( 2))

      @i01 = Music::LBDMInterval.new(@n0, @n1)
      @i12 = Music::LBDMInterval.new(@n1, @n2)

      @i01.next_interval = @i12
      @i12.prev_interval = @i01

      @i12.r_before.should be_within(0.001).of(0.0)
    end
    it "should return 0.5 if the current interval is the opposite direction and way stronger than the preceding one" do
      @n0 = Music::Note.new(Music::Pitch.new(24), Music::Duration.new( 5))
      @n1 = Music::Note.new(Music::Pitch.new(20), Music::Duration.new( 2))
      @n2 = Music::Note.new(Music::Pitch.new(90), Music::Duration.new(22))

      @i01 = Music::LBDMInterval.new(@n0, @n1)
      @i12 = Music::LBDMInterval.new(@n1, @n2)

      @i01.next_interval = @i12
      @i12.prev_interval = @i01

      @i12.r_before.should be_within(0.02).of(0.5)
    end
    it "should return 1.0 if the current interval is exactly opposite the one before it" do
      @n0 = Music::Note.new(Music::Pitch.new(90), Music::Duration.new(22))
      @n1 = Music::Note.new(Music::Pitch.new(20), Music::Duration.new( 2))
      @n2 = Music::Note.new(Music::Pitch.new(90), Music::Duration.new(22))

      @i01 = Music::LBDMInterval.new(@n0, @n1)
      @i12 = Music::LBDMInterval.new(@n1, @n2)

      @i01.next_interval = @i12
      @i12.prev_interval = @i01

      @i12.r_before.should be_within(0.001).of(1.0)
    end
    it "should return 1.0 if the current interval is exactly opposite the one before it" do
      @n0 = Music::Note.new(Music::Pitch.new(20), Music::Duration.new( 2))
      @n1 = Music::Note.new(Music::Pitch.new(90), Music::Duration.new(22))
      @n2 = Music::Note.new(Music::Pitch.new(20), Music::Duration.new( 2))

      @i01 = Music::LBDMInterval.new(@n0, @n1)
      @i12 = Music::LBDMInterval.new(@n1, @n2)

      @i01.next_interval = @i12
      @i12.prev_interval = @i01

      @i12.r_before.should be_within(0.001).of(1.0)
    end
  end

  context "r_after" do
    it "should be 0.0 if you haven't set the next interval" do
      @n0 = Music::Note.new(Music::Pitch.new(20), Music::Duration.new( 2))
      @n1 = Music::Note.new(Music::Pitch.new(20), Music::Duration.new( 2))
      @n2 = Music::Note.new(Music::Pitch.new(20), Music::Duration.new( 2))

      @i01 = Music::LBDMInterval.new(@n0, @n1)
      @i12 = Music::LBDMInterval.new(@n1, @n2)

      @i01.next_interval = @i12
      @i12.prev_interval = @i01

      @i12.r_after.should be_within(0.001).of(0.0)
    end
    it "should return 0.0 if the current interval is the same as the prior one" do
      @n0 = Music::Note.new(Music::Pitch.new(20), Music::Duration.new( 1))
      @n1 = Music::Note.new(Music::Pitch.new(20), Music::Duration.new( 5))
      @n2 = Music::Note.new(Music::Pitch.new(20), Music::Duration.new( 9))

      @i01 = Music::LBDMInterval.new(@n0, @n1)
      @i12 = Music::LBDMInterval.new(@n1, @n2)

      @i01.next_interval = @i12
      @i12.prev_interval = @i01

      @i01.r_after.should be_within(0.001).of(0.0)
    end
    it "should return 0.5 if the current interval is opposite and 2x as strong as the previous one" do
      @n0 = Music::Note.new(Music::Pitch.new(24), Music::Duration.new( 5))
      @n1 = Music::Note.new(Music::Pitch.new(20), Music::Duration.new( 2))
      @n2 = Music::Note.new(Music::Pitch.new(50), Music::Duration.new(12))

      @i01 = Music::LBDMInterval.new(@n0, @n1)
      @i12 = Music::LBDMInterval.new(@n1, @n2)

      @i01.next_interval = @i12
      @i12.prev_interval = @i01

      @i01.r_after.should be_within(0.02).of(0.5)
    end
    it "should return 1.0 if the current interval is exactly opposite as the previous one" do
      @n0 = Music::Note.new(Music::Pitch.new( 0), Music::Duration.new( 0))
      @n1 = Music::Note.new(Music::Pitch.new(40), Music::Duration.new(10))
      @n2 = Music::Note.new(Music::Pitch.new( 0), Music::Duration.new( 0))

      @i01 = Music::LBDMInterval.new(@n0, @n1)
      @i12 = Music::LBDMInterval.new(@n1, @n2)

      @i01.next_interval = @i12
      @i12.prev_interval = @i01

      @i01.r_after.should be_within(0.001).of(1.0)
    end
  end

  context "s" do
    it "should return 0.0 if ???" do
      @n0 = Music::Note.new(Music::Pitch.new( 0), Music::Duration.new( 0))
      @n1 = Music::Note.new(Music::Pitch.new(40), Music::Duration.new(10))
      @n2 = Music::Note.new(Music::Pitch.new( 0), Music::Duration.new( 0))
      @n3 = Music::Note.new(Music::Pitch.new(40), Music::Duration.new(10))

      @i01 = Music::LBDMInterval.new(@n0, @n1) # +++
      @i12 = Music::LBDMInterval.new(@n1, @n2) # ---
      @i23 = Music::LBDMInterval.new(@n2, @n3) # +++

      @i01.next_interval = @i12
      @i12.prev_interval = @i01

      @i12.next_interval = @i23
      @i23.prev_interval = @i12

      @i12.s.should be_within(0.001).of(0.0)
    end
    it "should return 0.5 if ???" do
      @n0 = Music::Note.new(Music::Pitch.new( 0), Music::Duration.new( 0))
      @n1 = Music::Note.new(Music::Pitch.new(40), Music::Duration.new(10))
      @n2 = Music::Note.new(Music::Pitch.new(50), Music::Duration.new(13))
      @n3 = Music::Note.new(Music::Pitch.new(40), Music::Duration.new(10))

      @i01 = Music::LBDMInterval.new(@n0, @n1) # ++
      @i12 = Music::LBDMInterval.new(@n1, @n2) # +
      @i23 = Music::LBDMInterval.new(@n2, @n3) # -

      @i01.next_interval = @i12
      @i12.prev_interval = @i01

      @i12.next_interval = @i23
      @i23.prev_interval = @i12

      @i12.s.should be_within(0.001).of(0.5)
    end
    it "should return 1.0 if ???" do
      @n0 = Music::Note.new(Music::Pitch.new( 0), Music::Duration.new( 0))
      @n1 = Music::Note.new(Music::Pitch.new(40), Music::Duration.new(10))
      @n2 = Music::Note.new(Music::Pitch.new(80), Music::Duration.new(20))
      @n3 = Music::Note.new(Music::Pitch.new(40), Music::Duration.new(10))

      @i01 = Music::LBDMInterval.new(@n0, @n1) # ++
      @i12 = Music::LBDMInterval.new(@n1, @n2) # ++
      @i23 = Music::LBDMInterval.new(@n2, @n3) # --

      @i01.next_interval = @i12
      @i12.prev_interval = @i01

      @i12.next_interval = @i23
      @i23.prev_interval = @i12

      @i12.s.should be_within(0.001).of(1.0)
    end
  end

end
