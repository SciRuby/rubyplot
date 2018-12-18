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
          @normalized_data[:y_values].each_with_index do |iy, idx_y|
            ix = @normalized_data[:x_values][idx_y]
            next if iy.nil? || ix.nil?

            abs_x = ix * @axes.x_axis.length + @axes.abs_x + @axes.y_axis_margin
            abs_y = (@axes.y_axis.length - iy * @axes.y_axis.length) + @axes.abs_y
            Rubyplot::Artist::Circle.new(
              self, abs_x: abs_x, abs_y: abs_y, radius: @circle_radius, stroke_opacity: @stroke_opacity,
                    stroke_width: @stroke_width
            ).draw
          end
        end
      end
      # class Scatter
    end
    # module Plot
  end
  # module Artist
end
# module Rubyplot
