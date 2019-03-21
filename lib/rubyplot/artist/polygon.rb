module Rubyplot
  module Artist
    class Polygon < Base
      def initialize(x:, y:, fill_opacity: 1.0, color: :default, stroke: 'transparent')
        @x = x
        @y = y
        @fill_opacity = fill_opacity
        @color = color
        @stroke = stroke
      end

      def draw
        Rubyplot.backend.draw_polygon(
          x: @x,
          y: @y,
          border_color: @color,
          border_width: 1.0,
          border_type: :solid,
          fill_color: @color,
          fill_opacity: @fill_opacity
        )
      end
    end # class Polygon
  end # module Artist
end # module Rubyplot
