require_relative 'base'

module Rubyplot
  module Artist
    class XAxis < Axis::Base
      def initialize axes
        super
      end

      def draw
        Rubyplot.backend.draw_x_axis(
          origin: @axes.origin[0],
          major_ticks: @major_ticks,
          minor_ticks: @minor_ticks,
          major_ticks_count: @major_ticks_count
        )
      end

      private

      def configure_title
        @texts << Rubyplot::Artist::Text.new(
          @title,
          self,
          font_size: @axes.marker_font_size,
          abs_y: @axes.abs_y,
          abs_x: @axes.abs_x + (@abs_x2 - @abs_x1)/2
        )
      end
    end # class XAxis
  end # class Artist
end # module Rubyplot
