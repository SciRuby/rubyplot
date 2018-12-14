module Rubyplot
  module Artist
    class Circle < Base
      # rubocop:disable Metrics/ParameterLists
      def initialize(owner, abs_x:, abs_y:, radius:, stroke_opacity: 0.0,
        color: '#000000', stroke_width:)
        super(owner.backend, abs_x, abs_y)
        @owner = owner
        @radius = radius
        @stroke_width = stroke_width
        @stroke_opacity = stroke_opacity
        @color = color
        @backend = @owner.backend
      end
      # rubocop:enable Metrics/ParameterLists

      def draw
        @backend.draw_circle(
          x: @abs_x, y: @abs_y, radius: @radius, stroke_opacity: @stroke_opacity,
          stroke_width: @stroke_width, color: @color
        )
      end
    end
    # class Circle
  end
  # module Artist
end
# module Rubyplot
