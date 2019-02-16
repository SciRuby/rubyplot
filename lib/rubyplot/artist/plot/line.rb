module Rubyplot
  module Artist
    module Plot
      class Line < Artist::Plot::Base
        # Type of line to draw. Default solid.
        attr_writer :line_type
        # The number of times that you want the width to be of the graphic device. Default 1.0.
        attr_writer :line_width
        # Color of the line. Default black.
        attr_writer :line_color

        def initialize(*)
          super
          @line_width = 1.0
          @line_type = :solid
          @line_color = :black
        end

        def data(x_values, y_values=[])
          y_values = Array.new(x_values.size) { |i| i } if y_values.empty?
          super x_values, y_values
        end

        def draw
          Rubyplot.backend.draw_lines(
            x: @data[:x_values],
            y: @data[:y_values],
            width: @line_width,
            type: @line_type,
            color: @line_color
          )
        end
      end # class Line
    end # module Plot
  end # module Artist
end # module Rubyplot

