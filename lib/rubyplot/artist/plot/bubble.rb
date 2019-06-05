module Rubyplot
  module Artist
    module Plot
      class Bubble < Artist::Plot::Base
        # Width in pixels of the border of each bubble.
        attr_reader :border_width
        attr_reader :z_max, :z_min
        def initialize(*)
          super
          @bubbles = []
          @border_width = 1.0
        end

        def data x_values, y_values, z_values
          super(x_values, y_values)
          @data[:z_values] = z_values
        end

        def draw
          Rubyplot.backend.draw_markers(
            x: @data[:x_values],
            y: @data[:y_values],
            size: @data[:z_values],
            fill_color: @data[:color],
            type: :solid_circle
          )
        end
      end # class Bubble
    end # module Plot
  end # module Artist
end # module Rubyplot
