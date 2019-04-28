module Rubyplot
  module Artist
    module Plot
      class BoxPlot < Artist::Plot::Base
        # Determines the reach of the whiskers to beyond the first and third quartiles.
        # Where IQR is the interquartile range (Q3-Q1), the upper whisker will extend
        # to the datum less then Q3 + whiskers*IQR. Beyond the whiskers, data are considered
        # outliers and plotted as individual points.
        attr_accessor :whiskers
        attr_accessor :bar_width
        # Array of co-ordinates of the lower left corners of the box.
        attr_accessor :x_left_box
        
        def initialize(*)
          super
          @whiskers = 1.5
        end

        def process_data
          @y_min = @vectors.map(&:min).min
          @y_max = @vectors.map(&:max).max
          @x_min = 0
          @x_max = @vectors.size

          calculate_ranges!
        end

        def data vectors
          @vectors = vectors
        end

        def draw
        end

        private

        def calculate_ranges!
          @q1s = []
          @q3s = []
          @medians = []
          @mins = []
          @maxs = []
          
          @vectors.each do |vec|
            sorted_vec = vec.sort
            m = get_percentile 50, sorted_vec
            q1 = get_percentile 25, sorted_vec
            q3 = get_percentile 75, sorted_vec

            @medians << m
            @q1s << q1
            @q3s << q3

            iqr = q3 - q1

            @mins << q1 - @whiskers * iqr
            @maxs << q3 + @whiskers * iqr
          end
        end

        def get_percentile percentile, vec
          size = vec.size
          index = (size * (percentile / 100.0))
          
          if index - index.to_i != 0 # not a whole number
            vec[index.floor]
          else
            (vec[index.floor] + vec[index.floor - 1]) / 2.0
          end
        end
      end # class BoxPlot
    end # module Plot
  end # module Artist
end # module Rubyplot
