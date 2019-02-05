module Rubyplot
  module Artist
    module Plot
      class Scatter < Artist::Plot::Base
        # Radius of the scatter circles in pixels.
        attr_writer :circle_radius

        def initialize(*)
          super
          @marker_size = 1.0
          @marker_type = :circle
          @marker_color = :black
        end

        def marker_size= marker_size
          @marker_size = marker_size
        end

        # Set a symbol as the marker type for this plot. Should be one from
        # Rubyplot::MARKER_TYPES.
        #
        # @param marker_type [Symbol] Name of the marker to be used.
        def marker_type= marker_type
          @marker_type = marker_type
        end

        # Set a color from Rubyplot::Color::COLOR_INDEX as the color.
        #
        # @param marker_color [Symbol] Name of the color.
        def marker_color= marker_color
          @marker_color = marker_color
        end

        def draw
          Rubyplot.backend.draw_markers(
            x: @data[:x_values],
            y: @data[:y_values],
            marker_type: @marker_type,
            marker_color: @marker_color,
            marker_size: @marker_size
          )
        end
      end # class Scatter
    end # module Plot
  end # module Artist
end # module Rubyplot
