module Rubyplot
  module Artist
    class Axis
      class Base
        # Length in pixels of the arrow after the last major tick.
        FINISH_ARROW_LENGTH = 10.0

        attr_reader :label, :ticks, :major_ticks_count, :min_val, :max_val, :title
        attr_reader :abs_x1, :abs_x2, :abs_y1, :abs_y2, :backend

        attr_reader :stroke_width, :major_ticks

        def initialize(axes, title, min_val, max_val)
          @axes = axes
          @title = title
          @min_val = min_val
          @max_val = max_val
          @stroke_width = 1.0
          @backend = @axes.backend
          @major_ticks = []
        end
      end
      # class Base
    end
    # class Axis
  end
  # class Artist
end
# module Rubyplot
