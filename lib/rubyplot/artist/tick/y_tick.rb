module Rubyplot
  module Artist
    class YTick < Tick::Base
      def initialize(*)
        super
        @label = Rubyplot::Artist::Text.new(
          @label_text.to_s,
          @owner,
          abs_x: @abs_x - 5 - @label_distance,
          abs_y: @abs_y + @length,
          pointsize: @owner.marker_font_size,
        )
      end

      def draw
        @backend.draw_line(
          x1: @abs_x, y1: @abs_y, x2: @abs_x - @length, y2: @abs_y,
          stroke_opacity: @tick_opacity,
          stroke_width: @tick_width)
        @label.draw
      end
    end
    # class YTick
  end
  # module Artist
end
# module Rubyplot
