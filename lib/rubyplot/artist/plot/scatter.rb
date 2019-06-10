module Rubyplot
  module Artist
    module Plot
      class Scatter < Artist::Plot::Base
        attr_accessor :marker_size
        # Set a symbol as the marker type for this plot. Should be one from
        # Rubyplot::MARKER_TYPES.
        attr_accessor :marker_type
        # Set a color from Rubyplot::Color::COLOR_INDEX as the color of the
        # fill of the marker.        
        attr_accessor :marker_fill_color
        # Set a color from Rubyplot::Color::COLOR_INDEX as the color of the
        # border of the marker.
        attr_accessor :marker_border_color
        
        def initialize(*)
          super
          @marker_size = 1.0
          @marker_type = :circle
          @marker_border_color = :black
          # set fill to nil for the benefit of hollow markers so that legend
          # color defaults to :black in case user does not specify.
          @marker_fill_color = nil
        end

        # Color used for creating the legend. Defaults to the marker_fill_color
        # but will use the marker_border_color if marker_fill_color does not
        # exist (for example for hollow circles).
        def color
          @marker_fill_color || @marker_border_color || :default
        end

        # Set both marker_fill_color and marker_border_color to the same color.
        def color= color
          @marker_fill_color = color
          @marker_border_color = color
        end

        def draw
          Rubyplot.backend.draw_markers(
            x: @data[:x_values],
            y: @data[:y_values],
            type: @marker_type,
            fill_color: @marker_fill_color,
            border_color: @marker_border_color,
            size: [@marker_size] * @data[:x_values].size
          )
        end
      end # class Scatter
    end # module Plot
  end # module Artist
end # module Rubyplot
