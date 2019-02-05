module Rubyplot
  module Artist
    class Axis
      class Base
        # Length of the arrow after the last major tick.
        FINISH_ARROW_LENGTH = 2.0

        # Array of Rubyplot::XTick objects representing major ticks.
        attr_accessor :major_ticks
        # Number of ticks to be plotted.
        attr_reader :major_ticks_count
        # Title (or label) given to this Axis.
        attr_accessor :title
        # The minimum value that this Axis contains.
        attr_accessor :min_val
        # The maximum value that this Axis contains.
        attr_accessor :max_val
        attr_accessor :minor_ticks # TODO
        attr_reader :abs_x1, :abs_x2, :abs_y1, :abs_y2, :length
        attr_reader :stroke_width

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

        def spread
          (@max_val - @min_val).abs
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
