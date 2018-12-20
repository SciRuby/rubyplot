module Rubyplot
  module Artist
    class Axis
      class Base
        # Length in pixels of the arrow after the last major tick.
        FINISH_ARROW_LENGTH = 10.0
        
        attr_reader :label, :ticks, :major_ticks_count
        attr_reader :abs_x1, :abs_x2, :abs_y1, :abs_y2, :backend, :length
        attr_reader :stroke_width, :major_ticks
        attr_accessor :title, :min_val, :max_val
        
        def initialize axes
          @axes = axes
          @title = ""
          @min_val = nil
          @max_val = nil
          @stroke_width = 1.0
          @backend = @axes.backend
          @major_ticks_count = 5
          @x_ticks = nil
        end
      end # class Base
    end # class Axis
  end # class Artist
end # module Rubyplot
