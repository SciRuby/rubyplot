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
