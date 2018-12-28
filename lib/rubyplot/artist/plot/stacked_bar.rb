module Rubyplot
  module Artist
    module Plot
      class StackedBar < Artist::Plot::Base
        # Ratio of the total avialable width that is left as padding space.
        attr_accessor :spacing_ratio
        # Array of X co-ordinates of the lower left corner of each stacked bar.
        attr_accessor :abs_x_left
        # Array of Y co-ordinates of the lower left corner of each stacked bar.
        attr_accessor :abs_y_left
        # Width in pixels of each bar.
        attr_accessor :bar_width

        def initialize(*)
          super
          @spacing_ratio = 0.1
          @abs_x_left = []
          @abs_y_left = []
          @rectangles = []
          @renormalized_y_values = []
        end

        def data y_values
          super(Array(0...(y_values.size)), y_values)
        end

        def num_bars
          @data[:y_values].size
        end

        # Normalize this data w.r.t other plots in this graph.
        #
        # @param max_plots [Integer] Max number of stacked bars in this plot.
        def renormalize max_plots
          @renormalized_y_values = @normalized_data[:y_values].map do |iy|
            iy / max_plots
          end
        end

        # Return the height in pixels of the bar at 'index'.
        def member_height index
          @renormalized_y_values[index] * @axes.y_axis.length
        end

        def draw
          setup_bar_rectangles
          @rectangles.each(&:draw)
        end

        private

        def setup_bar_rectangles
          @renormalized_y_values.each_with_index do |iy, i|
            height = iy * @axes.y_axis.length
            @rectangles << Rubyplot::Artist::Rectangle.new(
              self,
              abs_x: @abs_x_left[i],
              abs_y: @abs_y_left[i] - height,
              width: @bar_width,
              height: height,
              border_color: @data[:color],
              fill_color: @data[:color]
            )
          end
        end
      end
      # class StackedBar
    end
    # module Plot
  end
  # module Artist
end
# module Rubyplot
