module Rubyplot
  module Artist
    class Axis
      class Base
        # Length of the arrow after the last major tick.
        FINISH_ARROW_LENGTH = 2.0

        # Array of Rubyplot::XTick objects representing major ticks.
        attr_accessor :major_ticks
        attr_accessor :minor_ticks
        attr_reader :major_ticks_count
        attr_reader :abs_x1, :abs_x2, :abs_y1, :abs_y2, :backend, :length
        attr_reader :stroke_width
        attr_accessor :title, :min_val, :max_val

        def initialize axes
          @axes = axes
          @title = ''
          @min_val = nil
          @max_val = nil
          @stroke_width = 0.125
          @major_ticks_count = 5
          @texts = []
          @lines = []
          @major_ticks = nil
          @minor_ticks = nil
        end

        def draw
          configure_title
          configure_axis_line
          @lines.each(&:draw)
          @texts.each(&:draw)
          @major_ticks.each(&:draw)
        end
      end # class Base
    end # class Axis
  end # class Artist
end # module Rubyplot
