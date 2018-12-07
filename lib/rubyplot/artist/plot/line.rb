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

        def data x_values, y_values=[]
          y_values = Array.new(x_values.size) { |i| i } if y_values.empty?
          super x_values, y_values
        end

        def draw
          return unless @axes.geometry.has_data
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
          @normalized_data[:x_values].each_with_index do |ix, idx_ix|
            prev_x = prev_y = nil
            iy = @normalized_data[:y_values][idx_ix]
            new_x = ix * @axes.graph_width + @axes.graph_left
            new_y = @axes.graph_top + (@axes.graph_height - iy * @axes.graph_height)
            unless prev_x.nil? && prev_y.nil?
              Rubyplot::Artist::Line2D.new(
                x1: prev_x,
                y1: prev_y,
                x2: new_x,
                y2: new_y,
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

