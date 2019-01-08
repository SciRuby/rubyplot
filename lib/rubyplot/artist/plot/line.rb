module Rubyplot
  module Artist
    module Plot
      class Line < Artist::Plot::Base
        # Set true if you want to see only the vertices of the line plot.
        attr_writer :hide_lines

        def initialize(*)
          super
          @hide_lines = false
        end

        def data(x_values, y_values=[])
          y_values = Array.new(x_values.size) { |i| i } if y_values.empty?
          super x_values, y_values
        end

        def draw
          if @normalized_data[:x_values].size == 1
            draw_single_point
          else
            draw_lines
          end
        end

        private

        # FIXME: make this edge case happen.
        def draw_single_point
          # Rubyplot::Artist::Circle.new()
        end

        def draw_lines
          prev_x = prev_y = nil
          @normalized_data[:x_values].each_with_index do |ix, idx_ix|
            iy = @normalized_data[:y_values][idx_ix]
            next if ix.nil? || iy.nil?

            new_x = ix * (@axes.x_axis.abs_x2 - @axes.x_axis.abs_x1).abs + @axes.abs_x +
                    @axes.y_axis_margin
            new_y = (@axes.y_axis.length - iy * @axes.y_axis.length) + @axes.abs_y

            unless prev_x.nil? && prev_y.nil?
              Rubyplot::Artist::Line2D.new(
                self,
                abs_x1: prev_x,
                abs_y1: prev_y,
                abs_x2: new_x,
                abs_y2: new_y,
                stroke_opacity: @stroke_opacity,
                stroke_width: @stroke_width
              ).draw
            end
            prev_x = new_x
            prev_y = new_y
          end
        end
      end # class Line
    end # module Plot
  end # module Artist
end # module Rubyplot
