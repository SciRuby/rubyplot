module Rubyplot
  module Artist
    class Line2D
      def initialize(owner,x1:,y1:,x2:,y2:,color: '#000000',
                     stroke_opacity: 1.0, stroke_width:)
        @owner = owner
        @x1 = x1
        @y1 = y1
        @x2 = x2
        @y2 = y2
        @color = color
        @stroke_opacity = stroke_opacity
        @stroke_width = stroke_width
        @backend = @owner.backend
      end

      def draw
        @backend.draw_line(x1: @x1, y1: @y1, x2: @x2, y2: @y2, color: @color,
                           stroke_opacity: @stroke_opacity, stroke_width: @stroke_width)
      end
    end # class Line2D
  end # class Artist
end # module Rubyplot
