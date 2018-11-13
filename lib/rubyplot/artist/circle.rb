module Rubyplot
  module Artist
    class Circle < Base
      def initialize(owner, x, y, radius, stroke_opacity: 1.0,
                     color: '#000000', stroke_width:)
        @owner = owner
        @x = x
        @y = y
        @radius = radius
        @stroke_width = stroke_width
        @stroke_opacity = stroke_opacity
        @color = color
        @backend = @owner.backend
      end

      def draw
        @backend.draw_circle(
          x: @x, y: @y, radius: @radius, stroke_opacity: @stroke_opacity,
          stroke_width: @stroke_width, color: @color
        )
      end
    end # class Circle
  end # module Artist
end # module Rubyplot
