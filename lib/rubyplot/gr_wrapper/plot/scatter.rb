module Rubyplot
  module GRWrapper
    module Plot
      class Scatter < BasePlot::RobustBase
        def initialize axes
          super()
          @axes = axes
          @color = hex_color_to_gr_color_index(Rubyplot::Color::COLOR_INDEX[:black])
          @marker_size = 1
          @marker_type = GR_MARKER_SHAPES[:solid_circle]
        end

        def data x_values, y_values
          @axes.x_range[0] = x_values.min if @axes.x_range[0].nil?
          @axes.x_range[1] = x_values.max if @axes.x_range[1].nil?
          @axes.x_range[0] = x_values.min if x_values.min < @axes.x_range[0]
          @axes.x_range[1] = x_values.max if x_values.max > @axes.x_range[1]
          @axes.y_range[0] = y_values.min if @axes.y_range[0].nil?
          @axes.y_range[1] = y_values.max if @axes.y_range[1].nil?
          @axes.y_range[0] = y_values.min if y_values.min < @axes.y_range[0]
          @axes.y_range[1] = y_values.max if y_values.max > @axes.y_range[1]
          
          @x_values = x_values
          @y_values = y_values
        end

        def label= label
          # TODO : implement labels
        end

        def color= color
          @color = hex_color_to_gr_color_index(Rubyplot::Color::COLOR_INDEX[color])
        end

        def marker_size= marker_size
          @marker_size = marker_size
        end

        def marker_type= marker_type
          @marker_type = GR_MARKER_SHAPES[marker_type]
        end

        def call
          @tasks.push(SetMarkerColorIndex.new(@color))
          @tasks.push(SetMarkerSize.new(@marker_size))
          @tasks.push(SetMarkerType.new(@marker_type))
          @tasks.push(Polymarker.new(@x_values, @y_values))
        end
      end # class Scatter
    end # module Plot
  end # module GRWrapper
end # module Rubyplot
