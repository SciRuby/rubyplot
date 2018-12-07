module Rubyplot
  module Artist
    class XTick < Tick::Base
      def initialize(*)
        super
        scaled_width = @owner.geometry.raw_columns * @owner.scale
        scaled_width = scaled_width >=1 ? scaled_width : 1
        @label = Rubyplot::Artist::Text.new(
          @label_text.to_s,
          @owner,
          x: @x - 5,
          y: @y + @length + @label_distance,
          height: 1.0,
          width: scaled_width,
          pointsize: @owner.scale * @owner.marker_font_size,
        )
      end
      
      def draw
        @owner.backend.draw_line(
          x1: @x, y1: @y, x2: @x, y2: @y + @length, stroke_opacity: @tick_opacity,
          stroke_width: @tick_width)
        @label.draw
      end
    end
  end # class Artist
end # module Rubyplot
