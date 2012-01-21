#!/usr/bin/env ruby

module Music
  
  class BeatCrossSimilarityMatrix
    attr_accessor :width
  
    def initialize(beat_array1, beat_array2)
      while beat_array1.length < beat_array2.length
        beat_array1.push nil
      end
      while beat_array2.length < beat_array1.length
        beat_array2.push nil
      end

      @width = beat_array1.size
      @matrix = []
      (0..(beat_array1.size-1)).each do |x|
        @matrix[x] = []
        (0..x).each do |y|
          if beat_array1[x].nil? 
            @matrix[x][y] = 0.0
          else
            @matrix[x][y] = beat_array1[x].similarity_to beat_array2[y] 
          end
        end
      end
    end
  
    def val(x,y)
      return val(y, x) if x < y
      return @matrix[x][y]
    end

    def arithmetic_mean_of_diag(i, penalize_overhanging_notes=true)
      x = i
      y = 0
      sum = 0.0
      count = 0
      while x < @width
        sum += val(x, y)
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
        prod = prod * (1.0 + val(x, y))
        x += 1
        y += 1
      end
      return prod
    end

    def max_arithmetic_mean_of_diag(penalize_overhanging_notes=true)
      means = (0..(@width-1)).map{ |i| arithmetic_mean_of_diag(i, penalize_overhanging_notes) }
      return means.max
    end

    def max_geometric_mean_of_diag
      means = (0..(@width-1)).map{ |i| geometric_mean_of_diag(i) }
      return means.max
    end
  
    def autocorrel_of_main_diag(len)
      correls = [0.0]*len
      (0..(@width-1)).each do |i|
        correls[len - 1 - ((len -1 + i) % len)] += @matrix[i][i]
      end
      return correls
    end

    def print
      puts "\tmatrix:"
      (0..(@width-1)).each do |x|
        row = []
        (0..(@width-1)).each do |y|
          row.push sprintf("%4.2f", val(x,y))
        end
        puts "\t\t" + row.join(", ")
      end

      puts "\tarithmetic means:"
      means = (0..(@width-1)).map{ |i| arithmetic_mean_of_diag(i) }
      puts "\t\t" + means.map{ |x| sprintf("%5.3f", x) }.join(", ")
    end

  end

end
