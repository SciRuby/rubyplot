module Rubyplot
  module Artist
    class Line2D < Artist::Base
      # rubocop:disable Metrics/ParameterLists
      def initialize(owner, x1:,y1:,x2:,y2:,color: :black,
                     opacity: 0.0, width: 1.0)
        @owner = owner
        @x1 = x1
        @y1 = y1
        @x2 = x2
        @y2 = y2
        @color = color
        @opacity = opacity
        @width = width
      end
      # rubocop:enable Metrics/ParameterLists

      def draw
        Rubyplot.backend.draw_line(x1: @x1, y1: @y1, x2: @x2, y2: @y2,
          width: @width, color: @color, opacity: @opacity)
      end
    end # class Line2D
  end # class Artist
end # module Rubyplot
