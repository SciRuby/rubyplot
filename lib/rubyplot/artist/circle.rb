module Rubyplot
  module Artist
    class Circle < Base
      # rubocop:disable Metrics/ParameterLists
      def initialize(owner, x:, y:, radius:, border_opacity: 0.0,
                     color: :default, border_width:, abs: false)
        @x = x
        @y = y
        @owner = owner
        @radius = radius
        @border_width = border_width
        @border_opacity = border_opacity
        @color = color
        @abs = abs
      end
      # rubocop:enable Metrics/ParameterLists

      def draw
        Rubyplot.backend.draw_circle(
          x: @x,
          y: @y,
          radius: @radius,
          #          border_opacity: @border_opacity,
          border_type: :solid,
          border_width: @border_width,
          fill_color: @color,
          border_color: @color,
          fill_opacity: 1.0
        )
      end
    end # class Circle
  end # module Artist
end # module Rubyplot
