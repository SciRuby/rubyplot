module Rubyplot
  module Artist
    class Circle < Base
      # rubocop:disable Metrics/ParameterLists
      def initialize(owner, x:, y:, radius:, edge_opacity: 0.0,
                     color: :default, edge_width:, abs: false)
        @x = x
        @y = y
        @owner = owner
        @radius = radius
        @edge_width = width
        @edge_opacity = edge_opacity
        @color = color
        @abs = abs
      end
      # rubocop:enable Metrics/ParameterLists

      def draw
        Rubyplot.backend.draw_circle(
          x: @x,
          y: @y,
          radius: @radius,
          edge_opacity: @edge_opacity,
          edge_width: @edge_width,
          color: Rubyplot::Color::COLOR_INDEX[@color],
          abs: @abs
        )
      end
    end # class Circle
  end # module Artist
end # module Rubyplot
