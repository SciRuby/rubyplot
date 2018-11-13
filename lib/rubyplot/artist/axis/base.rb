module Rubyplot
  module Artist
    class Axis
      class Base
        attr_writer :label, :ticks, :major_ticks_count, :min_val, :max_val, :title
        attr_reader :backend
        
        def initialize axes, title, min_val, max_val
          @axes = axes
          @title = title.empty? ? '' : title
          @major_ticks_distance = 40.0
          @min_val = min_val
          @max_val = max_val
          @backend = @axes.backend
        end

        def draw
          @axes.backend.draw_line(x1: @x1, y1: @y1, x2: @x2, y2: @y2)
        end
      end # class Base
    end # class Axis
  end # class Artist
end # module Rubyplot
