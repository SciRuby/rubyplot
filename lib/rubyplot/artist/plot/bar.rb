module Rubyplot
  module Artist
    module Plot
      class Bar < Artist::Plot::Base
        # Space between the columns.
        attr_accessor :bar_spacing
        # Width of each bar in pixels.
        attr_accessor :bar_width
        # Height of each bar in pixels.
        attr_accessor :bar_height
        # Number between 0 and 1.0 denoting spacing between the bars.
        # 0.0 means no spacing at all 1.0 means that each bars' width
        # is nearly 0 (so each bar is a simple line with no X dimension).
        # Denotes the total left + right side space.
        attr_reader :spacing_ratio
        # X co-ordinate of the lower left corner of the bar.
        attr_accessor :abs_x_left
        # Y co-ordinate of the lower left corner of the bar.
        attr_accessor :abs_y_left
        def initialize(*)
          super
          @spacing_ratio = 0.1
        end

        # Set the spacing factor for this bar plot.
        def spacing_ratio= sf
          raise ValueError, '@spacing_ratio must be between 0.00 and 1.00' unless
            (sf >= 0) && (sf <= 1)
          @spacing_ratio = sf
        end

        # Set Bar plot data.
        def data y_values
          super(Array.new(y_values.size) { |i| i}, y_values)
        end

        # Number of bars in this Bar plot
        def num_bars
          @data[:y_values].size
        end

        def draw
          return unless @axes.geometry.has_data
          setup_bar_heights
        end

        private

        def setup_bar_heights
          
        end
      end # class Bar
    end # module Plot
  end # module Artist
end # module Rubyplot

