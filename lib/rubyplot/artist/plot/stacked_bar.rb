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

        def y_values
          @data[:y_values]
        end

        def num_bars
          @data[:y_values].size
        end

        def draw
          @data[:y_values].each_with_index do |iy, i|
            Rubyplot::Artist::Rectangle.new(
              self,
              x1: @abs_x_left[i],
              y1: @abs_y_left[i],
              x2: @abs_x_left[i] + @bar_width,
              y2: @abs_y_left[i] + iy,
              border_color: @data[:color],
              fill_color: @data[:color]
            ).draw
          end
        end
      end # class StackedBar
    end # module Plot
  end # module Artist
end # module Rubyplot
