#!/usr/bin/env ruby

module Music
  
  class BeatCrossSimilarityMatrix
    attr_reader :width
    attr_reader :val #2d array of [0..(width-1)][0..(1st index)]

    def initialize(beat_array1, beat_array2)
      while beat_array1.length < beat_array2.length
        beat_array1.push nil
      end
      while beat_array2.length < beat_array1.length
        beat_array2.push nil
      end

      @width = beat_array1.size
      @val = []
      (0..(beat_array1.size-1)).each do |x|
        @val[x] = []
        (0..x).each do |y|
          if beat_array1[x].nil? and beat_array2[y].nil? and (y>0) and (x>0)
            @val[x][y] = 0.6*@val[x-1][y-1]
          elsif beat_array1[x].nil? 
            @val[x][y] = 0.0
          else
            @val[x][y] = beat_array1[x].similarity_to beat_array2[y] 
          end
        end
      end
    end

    def arithmetic_mean_of_diag(i, penalize_overhanging_notes=true)
      x = i
      y = 0
      sum = 0.0
      count = 0
      while x < @width
        sum += @val[x][y]
        x += 1
        y += 1
        count += 1
      end

      return (sum-i) / @width.to_f if penalize_overhanging_notes
     
      return sum / count.to_f
    end

    def geometric_mean_of_diag(i)
      x = i
      y = 0
      prod = 1.0
      while x < @width
        prod = prod * (1.0 + @val[x][y])
        x += 1
        y += 1
      end
      return prod / 1.2**(@width-i)
    end

    def max_arithmetic_mean_of_diag(penalize_overhanging_notes=true)
      means = (0..(@width-1)).map{ |i| arithmetic_mean_of_diag(i, penalize_overhanging_notes) }
      return means.max
    end

    def max_geometric_mean_of_diag
      means = (0..(@width-1)).map{ |i| geometric_mean_of_diag(i) }
      return means.max
    end

    def print
      puts "\tmatrix:"
      (0..(@width-1)).each do |x|
        row = []
        (0..(@width-1)).each do |y|
          row.push sprintf("%4.2f", @val[x][y])
        end
        puts "\t\t" + row.join(", ")
      end

      puts "\tarithmetic means:"
      means = (0..(@width-1)).map{ |i| arithmetic_mean_of_diag(i) }
      puts "\t\t" + means.map{ |x| sprintf("%5.3f", x) }.join(", ")
    end

  end

end
