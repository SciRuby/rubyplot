module Rubyplot
  module Artist
    module Plot
      class Histogram < Artist::Plot::Base
        # Values that need to be shown as a histogram.
        attr_accessor :x
        # Array of bins into which the data should be subdivided.
        attr_accessor :bins
        
        def initialize(*)
          super 
        end

        def process_data
          groups = @x.group_by { |v| v }.map { |k,v| [k, v.size] }.sort_by { |a| a[0] }
          unique_nums = groups.map { |g| g[0] }
          freqs = groups.map { |g| g[1] }
          @bins = unique_nums.size unless @bins

          if @bins.is_a?(Array)
            unless @bins.each_cons(2).all? { |a, b| a <= b }
              raise RangeError, "Histogram bins must be consecutive"
            end
          elsif @bins.is_a?(Integer)
            subdivisions = (unique_nums.max - unique_nums.min) / @bins
            subdivisions = 1 if subdivisions == 0 
            @bins = Range.new(unique_nums.min, unique_nums.max).step(subdivisions).to_a
            @bins << unique_nums.last + subdivisions
          end
          combined_freqs = []
          
          @bins.each_cons(2) do |start, stop|
            sum = 0
            unique_nums.each_with_index do |num, i|
              if num >= start
                if (stop == freqs.last && num <= stop) || (stop != freqs.last && num < stop)
                  sum += freqs[i]
                end
              elsif num > stop
                break
              end
            end
            combined_freqs << sum
          end

          @x_min = @bins.first
          @x_max = @bins.last
          @y_min = freqs.min
          @y_max = freqs.max
        end

        def draw
        end
      end # class Histogram
    end # module Plot
  end # module Artist
end # module Rubyplot
