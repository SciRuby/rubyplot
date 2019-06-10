module Rubyplot
  module Artist
    module Plot
      class Area < Artist::Plot::Base
        attr_accessor :sort_data

        def initialize(*)
          super
          @sort_data = false
        end

        def data y_values, x_values=[]
          x_values = Array.new(y_values.size) { |i| i } if x_values.empty?
          y_values.sort! if @sort_data
          super(x_values, y_values)
        end

        def draw
          x_poly_points = @data[:x_values].concat([@axes.x_axis.max_val, @axes.x_axis.min_val])
          y_poly_points = @data[:y_values].concat([@axes.y_axis.min_val, @axes.y_axis.min_val])
          Rubyplot::Artist::Polygon.new(
            x: x_poly_points,
            y: y_poly_points,
            color: @data[:color],
            fill_opacity: 0.3
          ).draw
        end
      end # class Area
    end # module Plot
  end # module Artist
end # module Rubyplot
