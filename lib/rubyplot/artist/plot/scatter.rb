module Rubyplot
  module Artist
    module Plot
      class Scatter < Artist::Plot::Base
        attr_writer :stroke_width, :stroke_opacity, :circle_radius
        
        def initialize(*)
          super
          @normalized_data = {
            :y_values => nil,
            :x_values => nil
          }
          @points = []
          @stroke_width = 4.0
          @stroke_opacity = 1.0
          @circle_radius = 4.0
        end
        
        def data x_values, y_values
          super y_values
          @data[:x_values] = x_values
          if @axes.geometry.x_max_value.nil? && @axes.geometry.x_min_value.nil?
            @axes.geometry.x_max_value = @axes.geometry.x_min_value = x_values.first
          end
          @axes.geometry.x_max_value = x_values.max > @axes.geometry.x_max_value ?
                                    x_values.max : @axes.geometry.x_max_value
          @axes.geometry.x_min_value = x_values.min < @axes.geometry.x_min_value ?
                                    x_values.min : @axes.geometry.x_min_value
        end

        # Normalize original data between the spread of the data.
        def normalize x_spread, y_spread
          @normalized_data[:x_values] = @data[:x_values].map do |x|
            (x.to_f - @axes.geometry.x_min_value) / x_spread
          end
          @normalized_data[:y_values] = @data[:y_values].map do |y|
            (y.to_f - @axes.geometry.y_min_value) / y_spread
          end
        end

        def create_legend
          Rubyplot::Artist::Legend.new(@axes, @data[:label], @data[:color])
        end

        def label= label
          @data[:label] = label
        end

        def color= color
          @data[:color] = Rubyplot::Color::COLOR_INDEX[color]
        end

        def draw
          @x_increment = if @axes.geometry.column_count > 1
                           (@axes.graph_width / (@axes.geometry.column_count-1)).to_f
                         else
                           @axes.graph_width
                         end
          @normalized_data[:y_values].each_with_index do |iy, idx_y|
            ix = @normalized_data[:x_values][idx_y]
            next if iy.nil? || ix.nil?
            relative_ix = ix * @axes.graph_width + @axes.graph_left
            relative_iy = @axes.graph_top + (@axes.graph_height -
                                             iy * @axes.graph_height)
            Rubyplot::Artist::Circle.new(
              self,
              relative_ix,
              relative_iy,
              @circle_radius,
              stroke_opacity: @stroke_opacity,
              stroke_width: @stroke_width
            ).draw
          end
        end
      end # class Scatter
    end # module Plot
  end # module Artist
end # module Rubyplot
