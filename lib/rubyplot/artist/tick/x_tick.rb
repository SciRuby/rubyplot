module Rubyplot
  module Artist
    class XTick < Tick::Base
      def initialize(*)
        super
        @label = Rubyplot::Artist::Text.new(
          @label_text.to_s,
          @owner,
          abs_x: @abs_x - 2,
          abs_y: @abs_y - (@length + @label_distance),
          pointsize: @owner.marker_font_size
        )
      end

      def draw
        Rubyplot.backend.draw_line(
          x1: @abs_x, y1: @abs_y, x2: @abs_x, y2: @abs_y - @length,
          stroke_opacity: @tick_opacity,
          stroke_width: @tick_width
        )
        @label.draw
      end
    end # class XTick
  end # class Artist
end # module Rubyplot
