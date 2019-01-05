require_relative 'base'

module Rubyplot
  module Artist
    class XAxis < Axis::Base
      def initialize axes
        super
        @abs_x1 = @axes.origin[0]
        @abs_x2 = @axes.abs_x + @axes.width - @axes.y_axis_margin
        @major_ticks_distance = (@abs_x2 - @abs_x1) / @major_ticks_count
        @length = (@abs_x2 - @abs_x1).abs
        configure_axis_line
      end

      private

      def configure_axis_line
        @lines << Rubyplot::Artist::Line2D.new(
          self, abs_x1: @abs_x1, abs_y1: @axes.origin[1], abs_x2: @abs_x2, abs_y2: @axes.origin[1],
                stroke_width: @stroke_width
        )
      end

      def configure_title
        @texts << Rubyplot::Artist::Text.new(
          @title,
          self,
          pointsize: @axes.marker_font_size,
          abs_y: @axes.origin[1] + 20,
          abs_x: @axes.origin[0] + (@abs_x2 - @abs_x1)/2
        )
      end
    end # class XAxis
  end # class Artist
end # module Rubyplot
