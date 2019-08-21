module Rubyplot
  module Artist
    module Plot
      class Line < Artist::Plot::Base
        # Type of line to draw. Default solid.
        attr_writer :line_type
        # The number of times that you want the width to be of the graphic device. Default 1.0.
        attr_writer :line_width
        # Opacity of the line. Default is 1.
        attr_writer :line_opacity

        def line_color=(color)
          @line_color = color
          @data[:color] = color
        end

        def initialize(*)
          super
          @line_width = 1.0
          @line_type = :solid
          @line_color = :black
          @line_opacity = 1.0
        end

        def data(x_values, y_values)
          super x_values, y_values
        end

        def draw
          Rubyplot.backend.draw_lines(
            x: @data[:x_values],
            y: @data[:y_values],
            width: @line_width,
            type: @line_type,
            color: @line_color,
            opacity: @line_opacity
          )
        end
      end # class Line
    end # module Plot
  end # module Artist
end # module Rubyplot
