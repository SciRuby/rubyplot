module Rubyplot
  module Artist
    module Plot
      class BoxPlot < Artist::Plot::Base
        # Determines the reach of the whiskers to beyond the first and third quartiles.
        # Where IQR is the interquartile range (Q3-Q1), the upper whisker will extend
        # to the datum less then Q3 + whiskers*IQR. Beyond the whiskers, data are considered
        # outliers and plotted as individual points.
        attr_accessor :whiskers
        attr_accessor :box_width
        # Array of co-ordinates of the lower left corners of the box.
        attr_accessor :x_left_box
        
        def initialize(*)
          super
          @whiskers = 1.5
          @x_left_box = []
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
          @x_left_box.each_with_index do |x_left, i|
            draw_box x_left, i
            draw_whiskers x_left, i
            # draw_outliers x_left
            # draw_medians x_left    
          end
        end

        private

        def draw_box x_left, index
          Rubyplot::Artist::Rectangle.new(self,
            x1: x_left,
            x2: x_left + @box_width,
            y1: @q1s[index],
            y2: @q3s[index],
            border_color: :black
          ).draw
        end

        def draw_whiskers x_left, index
          Rubyplot::Artist::Line2D.new(self,
            x: [x_left + @box_width, x_left + @box_width],
            y: [@q3s[index], @max[index]]
          ).draw                # top whisker

          Rubyplot::Artist::Line2D.new(self,
            x: [x_left + @box_width, x_left + @box_width],
            y: [@q1s[index], @min[index]]
          ).draw
        end

        def draw_outliers
          
        end

        def draw_median
          
        end

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

            if sorted_vec[0] >= q1 - @whiskers * iqr
              @mins << sorted_vec[0]
            else
              @mins << q1 - @whiskers * iqr
            end

            if sorted_vec.last <= q3 + @whiskers * iqr
              @maxs << sorted_vec.last
            else
              @maxs << q3 + @whiskers * iqr
            end
          end
        end

        def get_percentile percentile, vec
          size = vec.size
          if size == 2
           return vec[0] + ((vec[1]-vec[0])) * (percentile / 100.0) 
          end
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
