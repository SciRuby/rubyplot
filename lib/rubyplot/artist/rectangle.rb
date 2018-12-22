module Rubyplot
  module Artist
    class Rectangle < Base
      attr_reader :width, :height, :border_color, :fill_color

      # Create a Rectangle for drawing on the canvas.
      #
      # @param abs_x [Float] Absolute X co-ordinate of the upper left corner.
      # @param abs_y [Float] Absolute Y co-ordinate of the upper left corner.
      # @param width [Float] Width in pixels of the rectangle.
      # @param height [Float] Height in pixels of the rectangle.
      # @param border_color [Symbol] Symbol from Rubyplot::Color::COLOR_INDEX
      #   denoting border color.
      # @param fill_color [Symbol] nil Symbol from Rubyplot::Color::COLOR_INDEX
      #   denoting the fill color.
      def initialize(owner,abs_x:,abs_y:,width:,height:,border_color:,fill_color: nil)
        super(owner.backend, abs_x, abs_y)
        @height = height
        @width = width
        @border_color = Rubyplot::Color::COLOR_INDEX[border_color]
        @fill_color = Rubyplot::Color::COLOR_INDEX[fill_color] if fill_color
      end

      def draw
        @backend.draw_rectangle(
          x1: @abs_x,
          y1: @abs_y,
          x2: @abs_x + @width,
          y2: @abs_y + @height,
          border_color: @border_color,
          fill_color: @fill_color
        )
      end
    end # class Rectangle
  end # class Artist
end # moduel Rubyplot
