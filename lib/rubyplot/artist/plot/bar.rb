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
        attr_reader :spacing_ratio
        def initialize(*)
          super
          @spacing_ratio = 0.1
        end

        # Set the spacing factor for this bar plot.
        def spacing_factor=(s_f)
          raise ValueError, '@spacing_factor must be between 0.00 and 1.00' unless
            (s_f >= 0) && (s_f <= 1)

          @spacing_factor = s_f
        end

        # Set Bar plot data.
        def data y_values
          @data[:y_values] = y_values
          set_yrange
        end

        # Number of bars in this Bar plot
        def num_bars
          @data[:y_values].size
        end

        def draw
          super
          return unless @axes.geometry.has_data

          configure_bars
        end

        private

        # FIXME: handle positive and negative bars.
        def configure_bars
          x_axis_length = @axes.x_axis.abs_x2 - @axes.x_axis.abs_x1
          @bar_width = coords_width / @data[:y_values].to_f
          padding = @bar_width * @spacing_ratio / 2
          @normalized_data[:y_values].each_with_index do |_iy, index|
            ix = @normalized_data[:x_values][index]
            ix * x_axis_length
          end
        end
      end
      # class Bar
    end
    # module Plot
  end
  # module Artist
end
# module Rubyplot
