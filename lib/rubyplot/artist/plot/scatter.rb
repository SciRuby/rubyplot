module Rubyplot
  module Artist
    module Plot
      class Scatter < Artist::Plot::Base
        attr_writer :circle_radius
        
        def initialize(*)
          super
          @circle_radius = 4.0
        end

        def draw
          puts "data: #{@data}"
          puts "norm: #{@normalized_data}"
          y_axis_length = (@axes.y_axis.abs_y2 - @axes.y_axis.abs_y1).abs
          @normalized_data[:y_values].each_with_index do |iy, idx_y|
            ix = @normalized_data[:x_values][idx_y]
            next if iy.nil? || ix.nil?
            abs_x = ix * (@axes.x_axis.abs_x2 - @axes.x_axis.abs_x1).abs + @axes.abs_x +
                    @axes.y_axis_margin
            abs_y = (y_axis_length - iy * y_axis_length) + @axes.abs_y
            Rubyplot::Artist::Circle.new(
              self,
              abs_x: abs_x,
              abs_y: abs_y,
              radius: @circle_radius,
              stroke_opacity: @stroke_opacity,
              stroke_width: @stroke_width
            ).draw
          end
        end
      end # class Scatter
    end # module Plot
  end # module Artist
end # module Rubyplot
