module Rubyplot
  module Artist
    module Plot
      class Bar < Artist::Plot::Base
        # Space between the columns.
        attr_accessor :bar_spacing
        # Width of each bar.
        attr_accessor :bar_width
        # Number between 0 and 1.0 denoting spacing between the bars.
        # 0.0 means no spacing at all 1.0 means that each bars' width
        # is nearly 0 (so each bar is a simple line with no X dimension).
        # Denotes the total left + right side space.
        attr_reader :spacing_ratio
        # X co-ordinates of the lower left corner of the bar.
        attr_accessor :abs_x_left
        # Y co-ordinates of the lower left corner of the bar.
        attr_accessor :abs_y_left

        def initialize(*)
          super
          @spacing_ratio = 0.1
          @abs_x_left = []
          @abs_y_left = []
          @rectangles = []
        end

        # Set the spacing factor for this bar plot.
        def spacing_factor=(s_f)
          raise ValueError, '@spacing_factor must be between 0.00 and 1.00' unless
            (s_f >= 0) && (s_f <= 1)

          @spacing_factor = s_f
        end

        # Set Bar plot data.
        def data y_values
          super(Array.new(y_values.size) { |i| i }, y_values)
        end

        # Number of bars in this Bar plot
        def num_bars
          @data[:y_values].size
        end

        def draw
          setup_bar_rectangles
          @rectangles.each(&:draw)
        end

        private

        def setup_bar_rectangles
          @data[:y_values].each_with_index do |iy, i|
            puts "iy: #{iy}"
            @rectangles << Rubyplot::Artist::Rectangle.new(
              self,
              x1: @abs_x_left[i],
              y1: @abs_y_left[i],
              x2: @abs_x_left[i] + @bar_width,
              y2: iy,
              border_color: @data[:color],
              fill_color: @data[:color]
            )
          end
        end
      end # class Bar
    end # module Plot
  end # module Artist
end # module Rubyplot
