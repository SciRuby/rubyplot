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
        end

        def data y_values
          super(Array(0...(y_values.size)), y_values)
        end

        def num_bars
          @data[:y_values].size
        end

        def draw
          setup_bar_rectangles
          @rectangles.each(&:draw)
        end

        private

        def setup_bar_rectangles
        end
      end # class StackedBar
    end # module Plot
  end # module Artist
end # module Rubyplot
