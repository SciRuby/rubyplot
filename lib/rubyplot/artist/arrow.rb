module Rubyplot
  module Artist
    class Arrow < Artist::Base
      def initialize x1:, y1:, x2:, y2:, size: 0.5, style: :simple_single_ended
        @x1 = x1
        @y1 = y1
        @x2 = x2
        @y2 = y2
        @size = size
        @style = style
      end

      def draw
        Rubyplot.backend.draw_arrow(x1: @x1, y1: @y1, x2: @x2, y2: @y2,
          size: @size, style: @style)
      end
    end # class Arrow
  end # module Artist
end # module Rubyplot
