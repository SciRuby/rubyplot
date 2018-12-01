module Rubyplot
  module Artist
    class XTick < Tick::Base
      def initialize(*)
        super
        scaled_width = @artist.geometry.raw_columns * @artist.scale
        scaled_width = scaled_width >=1 ? scaled_width : 1
        @label = Rubyplot::Artist::Text.new(
          @label_text.to_s,
          @artist,
          x: @x - 5,
          y: @y + @length + @label_distance,
          height: 1.0,
          width: scaled_width,
          pointsize: @artist.scale * @artist.marker_font_size,
        )
      end
      
      def draw
        @artist.backend.draw_line(
          x1: @x, y1: @y, x2: @x, y2: @y + @length)
        @label.draw
      end
    end
  end # class Artist
end # module Rubyplot
