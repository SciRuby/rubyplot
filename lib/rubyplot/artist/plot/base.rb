module Rubyplot
  module Artist
    module Plot
      class Base < Artist::Base
        attr_reader :axes, :data
        attr_writer :stroke_width, :stroke_opacity

        def initialize(axes)
          @axes = axes
          @backend = @axes.backend
          @data = {
            label: :default,
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

        def color=(color)
          @data[:color] = Rubyplot::Color::COLOR_INDEX[color]
        end

        def data(x_values, y_values)
          @data[:x_values] = x_values
          @data[:y_values] = y_values
          # Set column count if this is larger than previous column counts
          @axes.geometry.column_count =if y_values.length > @axes.geometry.column_count then y_values.length
                                       else @axes.geometry.column_count
                                       end
          if @axes.y_range[0].nil? && @axes.y_range[1].nil?
            @axes.y_range[0] = y_values.min
            @axes.y_range[1] = y_values.max
          end
          if @axes.x_range[1].nil? && @axes.x_range[0].nil?
            @axes.x_range[0] = x_values.min
            @axes.x_range[1] = x_values.max
          end
          @axes.geometry.has_data = true
        end

        # Normalize original data to values between 0-100.
        def normalize
          x_min = @axes.x_range[0] < 0 ? @axes.x_range[0] : 0
          y_min = @axes.y_range[0] < 0 ? @axes.y_range[0] : 0
          x_spread = @axes.x_range[1] - x_min
          y_spread = @axes.y_range[1] - y_min
          @normalized_data[:x_values] = @data[:x_values].map do |x|
            (x.to_f - x_min) / x_spread
          end
          @normalized_data[:y_values] = @data[:y_values].map do |y|
            (y.to_f - y_min) / y_spread
          end
        end
      end
      # class Base
    end
    # module Plot
  end
  # module Artist
end
# module Rubyplot
