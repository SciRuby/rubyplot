module Rubyplot
  class Artist
    class Text
      # (X,Y) of upper left corner of the rectangle.
      attr_reader :x, :y, :height, :width, :color, :font, :pointsize,
                  :stroke, :weight, :gravity, :text
      
      def initialize(text, artist, x:, y:, height:, width:,font: nil,
                     color: '#000000',pointsize:,stroke: 'transparent',
                     weight: nil,gravity: nil)
        @text = text
        @artist = artist
        @x = x
        @y = y
        @height = height
        @width = width
        @font = font
        @color = color
        @pointsize = pointsize
        @stroke = stroke
      end

      def draw
        @artist.backend.draw_text(
          @text,
          font_color: @color,
          font: @font,
          pointsize: @pointsize,
          stroke: @stroke,
          width: @width,
          height: @height,
          x: @x,
          y: @y
        )
      end
    end # class Text
  end # class Artist
end # module Rubyplot
