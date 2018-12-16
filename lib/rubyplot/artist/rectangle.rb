module Rubyplot
  module Artist
    class Rectangle < Base
      attr_reader :width, :height, :border_color, :fill_color

      # rubocop:disable Metrics/ParameterLists
      def initialize(owner,abs_x:,abs_y:,width:,
        height:,border_color:,fill_color: nil)
        super(owner.backend, abs_x, abs_y)
        @height = height
        @width = width
        @border_color = Rubyplot::Color::COLOR_INDEX[border_color]
        @fill_color = Rubyplot::Color::COLOR_INDEX[fill_color] if fill_color
      end
      # rubocop:enable Metrics/ParameterLists

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
    end
    # class Rectangle
  end
  # class Artist
end
# moduel Rubyplot
