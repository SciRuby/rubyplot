module Rubyplot
  module Artist
    class Line2D < Artist::Base
      # rubocop:disable Metrics/ParameterLists
      def initialize(owner,abs_x1:,abs_y1:,abs_x2:,abs_y2:,color: '#000000',
        stroke_opacity: 0.0, stroke_width: 2.0)
        @owner = owner
        @abs_x1 = abs_x1
        @abs_y1 = abs_y1
        @abs_x2 = abs_x2
        @abs_y2 = abs_y2
        @color = color
        @stroke_opacity = stroke_opacity
        @stroke_width = stroke_width
      end
      # rubocop:enable Metrics/ParameterLists

      def draw
        Rubyplot.backend.draw_line(x1: @abs_x1, y1: @abs_y1, x2: @abs_x2, y2: @abs_y2,
                           stroke_width: @stroke_width)
      end
    end # class Line2D
  end # class Artist
end # module Rubyplot
