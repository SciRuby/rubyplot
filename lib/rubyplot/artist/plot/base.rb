module Rubyplot
  module Artist
    module Plot
      class Base < Artist::Base
        attr_reader :axes, :data, :x_max, :x_min, :y_min, :y_max
        attr_writer :stroke_width, :stroke_opacity

        def initialize axes
          super(axes.abs_x, axes.abs_y)
          @axes = axes
          @data = {
            label: '',
            color: :default
          }
          @normalized_data = {
            y_values: nil,
            x_values: nil
          }
          @stroke_width = 4.0
          @stroke_opacity = 0.0
        end

        def label
          @data[:label]
        end

        def color
          @data[:color]
        end

        def label=(label)
          @data[:label] = label
        end

        def color= color
          @data[:color] = color
        end

        def data(x_values, y_values)
          @data[:x_values] = x_values
          @data[:y_values] = y_values
          @y_min = @data[:y_values].min
          @y_max = @data[:y_values].max
          @x_min = @data[:x_values].min
          @x_max = @data[:x_values].max
        end

        def process_data
          
        end
      end # class Base
    end # module Plot
  end # module Artist
end # module Rubyplot
