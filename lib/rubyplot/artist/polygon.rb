module Rubyplot
  module Artist
    class Polygon < Base
      def initialize(owner, coords:, fill_opacity: 0.0, color: :default, stroke: 'transparent')
        @backend = owner.backend
        @coords = coords
        @fill_opacity = fill_opacity
        @color = color
        @stroke = stroke
      end

      def draw
        Rubyplot.backend.draw_polygon(
          coords: @coords,
          stroke: @stroke,
          color: Rubyplot::Color::COLOR_INDEX[@color],
          fill_opacity: @fill_opacity
        )
      end
    end # class Polygon
  end # module Artist
end # module Rubyplot
