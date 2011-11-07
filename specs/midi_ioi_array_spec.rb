# midi_ioi_array_spec.rb

require 'midi/event'
require 'midi/event_queue'
require 'midi/ioi_array'
require 'specs/vectors/midi'

describe Midi::IOIArray do

  before(:each) do
  end
     
  describe "#quantize!" do
    it "returns a hash containing the quantization value" do
      @i = Midi::IOIArray.new([81, 72, 64, 65, 64, 64, 120, 57, 87, 53, 69, 141, 129, 
                               63, 66, 65, 58, 61, 70, 116, 61, 60, 58, 63, 125])
      @goal =                 [ 1,  1,  1,  1,  1,  1,   2,  1,  1,  1,  1,   2,   2,   
                                1,  1,  1,  1,  1,  1,   2,  1,  1,  1,  1,   2]

      @q_ret = @i.quantize!
      @q_ret[:q].should be_within(5).of(64)
    end
  end
   
  describe "#quantize!" do
    it "returns a hash containing the quantization error" do
      @i = Midi::IOIArray.new([81, 72, 64, 65, 64, 64, 120, 57, 87, 53, 69, 141, 129, 
                               63, 66, 65, 58, 61, 70, 116, 61, 60, 58, 63, 125])
      @goal =                 [ 1,  1,  1,  1,  1,  1,   2,  1,  1,  1,  1,   2,   2,   
                                1,  1,  1,  1,  1,  1,   2,  1,  1,  1,  1,   2]

      @q_ret = @i.quantize!
      @q_ret[:err].should_not be_nil
    end
  end

  describe "#quantize!" do
    it "quantizes its array values according to the quantization value" do
      @i = Midi::IOIArray.new([81, 72, 64, 65, 64, 64, 120, 57, 87, 53, 69, 141, 129, 
                               63, 66, 65, 58, 61, 70, 116, 61, 60, 58, 63, 125])
      @goal =                 [ 1,  1,  1,  1,  1,  1,   2,  1,  1,  1,  1,   2,   2,   
                                1,  1,  1,  1,  1,  1,   2,  1,  1,  1,  1,   2]

      @q_ret = @i.quantize!

      @i.should == @goal
    end
  end

  describe "#quantize!" do
    it "quantizes its array values according to the quantization value" do
      @iois = Midi::IOIArray.new([257, 51, 54, 54, 63, 116, 111])
      @q_ret = @iois.quantize!
      @iois.should == [5, 1, 1, 1, 1, 2, 2]
    end
  end

  describe "#quantize!" do
    it "properly quantizes 'good king wencelis'" do
      @evq = Midi::EventQueue.new
      $test_vectors["good king wencelis"][:events].each do |event|
        @evq.enqueue(event)
      end
      @iois = @evq.get_interonset_intervals
      @q_ret = @iois.quantize!
      @iois.should == $test_vectors["good king wencelis"][:qiois]
    end
  end

  describe "#quantize!" do
    it "properly quantizes 'old macdonald had a farm'" do
      @evq = Midi::EventQueue.new
      $test_vectors["old macdonald had a farm"][:events].each do |event|
        @evq.enqueue(event)
      end
      @iois = @evq.get_interonset_intervals
      @q_ret = @iois.quantize!
      @iois.should == $test_vectors["old macdonald had a farm"][:qiois]
    end
  end

  describe "#quantize!" do
    it "properly quantizes 'mary had a little lamb'" do
      @evq = Midi::EventQueue.new
      $test_vectors["mary had a little lamb"][:events].each do |event|
        @evq.enqueue(event)
      end
      @iois = @evq.get_interonset_intervals
      #puts "    @iois: #{@iois.inspect}"
      @q_ret = @iois.quantize!
      #puts "    @q_ret: #{@q_ret}"
      #puts "    @iois: #{@iois.inspect}"
      @iois.should == $test_vectors["mary had a little lamb"][:qiois]
    end
  end

end
