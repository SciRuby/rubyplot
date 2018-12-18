module Rubyplot
  module Artist
    module Plot
      class Base < Artist::Base
        attr_reader :axes, :data, :x_max, :x_min, :y_min,
                    :y_max
        attr_writer :stroke_width, :stroke_opacity
        
        def initialize axes
          super(axes.backend, axes.abs_x, axes.abs_y)
          @axes = axes
          @backend = @axes.backend
          @data = {
            label: "",
            color: :default
          }
          @normalized_data = {
            :y_values => nil,
            :x_values => nil
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

        def label= label
          @data[:label] = label
        end

        def color= color
          @data[:color] = color
        end

        def data x_values, y_values
          @data[:x_values] = x_values
          @data[:y_values] = y_values
          # Set column count if this is larger than previous column counts
          @axes.geometry.column_count = y_values.length > @axes.geometry.column_count ?
                                          y_values.length : @axes.geometry.column_count
          @y_min = @data[:y_values].min
          @y_max = @data[:y_values].max
          @x_min = @data[:x_values].min
          @x_max = @data[:x_values].max

          @axes.geometry.has_data = true
        end

        # Normalize original data to values between 0-1. Used for obtaining relative
        # values of the data.
        def normalize
          x_spread = @axes.x_range[1] - @axes.x_range[0]
          y_spread = @axes.y_range[1] - @axes.y_range[0]
          @normalized_data[:x_values] = @data[:x_values].map do |x|
            (x.to_f - @axes.x_range[0]) / x_spread 
          end if @data[:x_values]
          @normalized_data[:y_values] = @data[:y_values].map do |y|
            (y.to_f - @axes.y_range[0]) / y_spread
          end if @data[:y_values]
        end
      end # class Base
    end # module Plot
  end # module Artist
end # module Rubyplot

