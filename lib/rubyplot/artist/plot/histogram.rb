module Rubyplot
  module Artist
    module Plot
      class Histogram < Artist::Plot::Base
        # Values that need to be shown as a histogram.
        attr_accessor :x
        # Array of bins into which the data should be subdivided.
        attr_accessor :bins
        # Width of each bar.
        attr_accessor :bar_width
        
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

          @step = (@bins[1] - @bins[0])
          @x_min = @bins.first - @step
          @x_max = @bins.last + @step
          @y_min = 0
          @y_max = combined_freqs.max
          @data[:x_values] = @bins
          @data[:y_values] = combined_freqs
          @bar_width = @step unless @bar_width
          @axes.x_axis.major_ticks_count = @bins.size - 1
        end

        def draw
          @data[:y_values].each_with_index do |iy, i|
            ix = @data[:x_values][i]
            Rubyplot::Artist::Rectangle.new(
              self,
              x1: @bins.first + i*@bar_width,
              y1: @y_min,
              x2: @bins.first + i*@bar_width + @bar_width,
              y2: iy,
              border_color: :black,
              fill_color: @data[:color]
            ).draw
          end
        end
      end # class Histogram
    end # module Plot
  end # module Artist
end # module Rubyplot
