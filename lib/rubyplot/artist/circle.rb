module Rubyplot
  module Artist
    class Circle < Base
      # rubocop:disable Metrics/ParameterLists
      def initialize(owner, abs_x:, abs_y:, radius:, edge_opacity: 0.0,
                     color: :default, edge_width:)
        super(abs_x, abs_y)
        @owner = owner
        @radius = radius
        @edge_width = width
        @edge_opacity = edge_opacity
        @color = color
      end
      # rubocop:enable Metrics/ParameterLists

      def draw
        Rubyplot.backend.draw_circle(
          x: @abs_x,
          y: @abs_y,
          radius: @radius,
          edge_opacity: @edge_opacity,
          edge_width: @edge_width,
          color: Rubyplot::Color::COLOR_INDEX[@color]
        )
      end
    end # class Circle
  end # module Artist
end # module Rubyplot
