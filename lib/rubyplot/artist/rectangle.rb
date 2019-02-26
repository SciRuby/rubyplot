module Rubyplot
  module Artist
    class Rectangle < Base
      attr_reader :x1, :x2, :y1, :y2, :border_color, :fill_color

      # Create a Rectangle for drawing on the canvas.
      #
      # @param x1 [Float] X co-ordinate of the lower left corner.
      # @param y1 [Float] Y co-ordinate of the lower left corner.
      # @param x2 [Float] X co-ordinate of upper right corner.
      # @param y2 [Float] Y co-ordinate of upper right corner.
      # @param border_color [Symbol] Symbol from Rubyplot::Color::COLOR_INDEX
      #   denoting border color.
      # @param fill_color [Symbol] nil Symbol from Rubyplot::Color::COLOR_INDEX
      #   denoting the fill color.
      # @param abs [FalseClass|TrueClass] false Whether the co-ordinates are absolute co-ordinates.
      # rubocop:disable Metrics/ParameterLists
      def initialize(owner,x1:,y1:,x2:,y2:,border_color:,fill_color: nil, abs: false)
        @x1 = x1
        @x2 = x2
        @y1 = y1
        @y2 = y2
        @border_color = border_color
        @fill_color = fill_color
        @abs = abs
      end
      # rubocop:enable Metrics/ParameterLists

      def draw
        Rubyplot.backend.draw_rectangle(
          x1: @x1,
          y1: @y1,
          x2: @x2,
          y2: @y2,
          border_color: @border_color,
          fill_color: @fill_color,
          abs: @abs
        )
      end
    end # class Rectangle
  end # class Artist
end # module Rubyplot
