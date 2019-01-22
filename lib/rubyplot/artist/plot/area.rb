module Rubyplot
  module Artist
    module Plot
      class Area < Artist::Plot::Base
        attr_accessor :sorted_data

        def initialize(*)
          super
          @sorted_data = true
        end

        def data x_values, y_values=[]
          y_values = Array.new(x_values.size) { |i| i } if y_values.empty?
          x_values.sort! if @sorted_data
          super(x_values, y_values)
        end

        def draw
          poly_points = []
          @normalized_data[:y_values].each_with_index do |iy, idx_y|
            ix = @normalized_data[:x_values][idx_y]
            abs_x = ix * @axes.x_axis.length + @axes.origin[0]
            abs_y = iy * @axes.y_axis.length + @axes.origin[1]
            poly_points << [abs_x, abs_y]
          end
          poly_points << [@axes.x_axis.abs_x2, @axes.origin[1] - @axes.x_axis.stroke_width]
          poly_points << [@axes.origin[0], @axes.origin[1] - @axes.x_axis.stroke_width]
          Rubyplot::Artist::Polygon.new(
            coords: poly_points,
            color: @data[:color],
            fill_opacity: 0.3
          ).draw
        end
      end # class Area
    end # module Plot
  end # module Artist
end # module Rubyplot
