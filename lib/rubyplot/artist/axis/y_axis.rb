module Rubyplot
  module Artist
    class YAxis < Axis::Base
      def initialize(*)
        super
      end

      def draw
        Rubyplot.backend.draw_y_axis(
          origin: @axes.origin[1],
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
          rotation: -90.0,
          abs_x: @axes.origin[0] - 3,
          abs_y: @length / 2,
          font_size: @axes.marker_font_size
        )
      end
    end # class YAxis
  end # class Artist
end # module Rubyplot
