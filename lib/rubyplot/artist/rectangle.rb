module Rubyplot
  module Artist
    class Rectangle < Base
      attr_reader :width, :height, :border_color, :fill_color

      # Create a Rectangle for drawing on the canvas.
      #
      # @param x [Float] X co-ordinate of the lower left corner.
      # @param y [Float] Y co-ordinate of the lower left corner.
      # @param width [Float] Width of the rectangle (as per range of X axis.).
      # @param height [Float] Height of the rectangle (as per range of Y axis).
      # @param border_color [Symbol] Symbol from Rubyplot::Color::COLOR_INDEX
      #   denoting border color.
      # @param fill_color [Symbol] nil Symbol from Rubyplot::Color::COLOR_INDEX
      #   denoting the fill color.

      # rubocop:disable Metrics/ParameterLists
      def initialize(owner,x:,y:,width:,height:,border_color:,fill_color: nil)
        super(x, y)
        @height = height
        @width = width
        @border_color = Rubyplot::Color::COLOR_INDEX[border_color]
        @fill_color = Rubyplot::Color::COLOR_INDEX[fill_color] if fill_color
      end
      # rubocop:enable Metrics/ParameterLists

      def draw
        Rubyplot.backend.draw_rectangle(
          x1: @x,
          y1: @y,
          x2: @x + @width,
          y2: @y + @height,
          border_color: @border_color,
          fill_color: @fill_color
        )
      end
    end # class Rectangle
  end # class Artist
end # module Rubyplot
