module Rubyplot
  module Artist
    module Plot
      class Bubble < Artist::Plot::Base
        # Width in pixels of the border of each bubble.
        attr_reader :stroke_width
        attr_reader :z_max, :z_min
        
        def initialize(*)
          super
          @bubbles = []
          @stroke_width = 1.0
        end

        def data x_values, y_values, z_values
          super(x_values, y_values)
          @data[:z_values] = z_values
          @z_max = @data[:z_values].max
          @z_min = @data[:z_values].min
        end

        def draw
          @normalized_data[:y_values].each_with_index do |iy, idx_y|
            ix = @normalized_data[:x_values][idx_y]
            iz = @data[:z_values][idx_y]
            abs_x = ix * @axes.x_axis.length + @axes.abs_x + @axes.y_axis_margin
            abs_y = (@axes.y_axis.length - iy * @axes.y_axis.length) + @axes.abs_y
            @bubbles << Rubyplot::Artist::Circle.new(
              self,
              abs_x: abs_x,
              abs_y: abs_y,
              radius: iz,
              color: @data[:color],
              stroke_width: @stroke_width
            )
          end
          @bubbles.each(&:draw)
        end
      end # class Bubble
    end # module Plot
  end # module Artist
end # module Rubyplot
