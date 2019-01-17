module Rubyplot
  module Artist
    class YAxis < Axis::Base
      def initialize(*)
        super
        @abs_y1 = @axes.origin[1]
        @abs_y2 = @axes.origin[1] + (@axes.height - @axes.x_axis_margin)
        @y_ticks = []
        @length = (@abs_y1 - @abs_y2).abs
        configure_axis_line
      end

      private

      def configure_axis_line
        @lines << Rubyplot::Artist::Line2D.new(
          self,
          abs_x1: @axes.origin[0],
          abs_y1: @abs_y1,
          abs_x2: @axes.origin[0],
          abs_y2: @abs_y2,
          stroke_width: @stroke_width
        )
      end

      def configure_title
        @texts << Rubyplot::Artist::Text.new(
          @title,
          self,
          rotation: -90.0,
          abs_x: @axes.origin[0] - 3,
          abs_y: (@abs_y1 - @abs_y2) / 2,
          pointsize: @axes.marker_font_size
        )
      end
    end # class YAxis
  end # class Artist
end # module Rubyplot
