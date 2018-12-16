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
            label: "",
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
          # Set column count if this is larger than previous column counts
          @axes.geometry.column_count =if y_values.length > @axes.geometry.column_count then y_values.length
                                       else @axes.geometry.column_count
                                       end
          set_yrange
          set_xrange
          @axes.geometry.has_data = true
        end

        # Normalize original data to values between 0-100.
        def normalize
          x_min = @axes.x_range[0] < 0 ? @axes.x_range[0] : 0
          y_min = @axes.y_range[0] < 0 ? @axes.y_range[0] : 0
          x_spread = @axes.x_range[1] - x_min
          y_spread = @axes.y_range[1] - y_min
          if @data[:x_values]
            @normalized_data[:x_values] = @data[:x_values].map do |x|
              (x.to_f - x_min) / x_spread
            end
          end
          if @data[:y_values]
            @normalized_data[:y_values] = @data[:y_values].map do |y|
              (y.to_f - y_min) / y_spread
            end
          end
        end

        protected

        def set_xrange
          if @axes.x_range[1].nil? && @axes.x_range[0].nil?
            @axes.x_range[0] = @data[:x_values].min
            @axes.x_range[1] = @data[:x_values].max
          end
        end

        def set_yrange
          if @axes.y_range[0].nil? && @axes.y_range[1].nil?
            @axes.y_range[0] = @data[:y_values].min
            @axes.y_range[1] = @data[:y_values].max
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
