module Rubyplot
  module Artist
    class Line2D < Artist::Base
      # rubocop:disable Metrics/ParameterLists
      def initialize(owner, x:,y:,color: :black, opacity: 0.0, width: 1.0, type: :solid)
        @owner = owner
        @x = x
        @y = y
        @color = color
        @opacity = opacity
        @width = width
        @type = type
      end
      # rubocop:enable Metrics/ParameterLists

      def draw
        Rubyplot.backend.draw_lines(x: @x, y: @y,
          width: @width, color: @color, opacity: @opacity, type: @type)
      end
    end # class Line2D
  end # class Artist
end # module Rubyplot
