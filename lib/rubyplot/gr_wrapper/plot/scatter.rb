module Rubyplot
  module GRWrapper
    module Plot
      class Scatter < BasePlots::RobustBase
        def initialize(x_coordinates, y_coordinates, marker_size: :default,
                       marker_color: :default, marker_type: :default)
          super()
          marker_color = Rubyplot::Color::COLOR_INDEX[:black] if marker_color == :default
          marker_color = Rubyplot::Color::COLOR_INDEX[marker_color] if marker_color.is_a? Symbol
          marker_size = 1 if marker_size == :default
          marker_type = :solid_circle if marker_type == :default
          @tasks.push(SetMarkerColorIndex.new(hex_color_to_gr_color_index(marker_color)))
          @tasks.push(SetMarkerSize.new(marker_size))
          @tasks.push(SetMarkerType.new(GR_MARKER_SHAPES[marker_type]))
          @tasks.push(Polymarker.new(x_coordinates, y_coordinates))
        end
      end
    end
  end
end
