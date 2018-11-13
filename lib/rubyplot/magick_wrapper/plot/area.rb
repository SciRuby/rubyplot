require_relative 'area/geometry'

module Rubyplot
  module MagickWrapper
    module Plot
      class Area < Artist
        def initialize(*)
          super
          @sorted_drawing = true
          @all_colors_array = Magick.colors
        end

        def draw
          super
          return unless @geometry.has_data

          @x_increment = @graph_width / (@geometry.column_count - 1).to_f
          @d = @d.stroke 'transparent'

          @geometry.norm_data.each_with_index do |data_row, i|
            poly_points = []
            prev_x = prev_y = 0.0
            @d = @d.fill @plot_colors[i]

            data_row[DATA_VALUES_INDEX].each_with_index do |data_point, index|
              # Use incremented x and scaled y
              new_x = @graph_left + (@x_increment * index)
              new_y = @graph_top + (@graph_height - data_point * @graph_height)

              poly_points << new_x
              poly_points << new_y

              draw_label(new_x, index)

              prev_x = new_x
              prev_y = new_y
            end

            # Add closing points, draw polygon
            poly_points << @graph_right
            poly_points << @graph_bottom - 1
            poly_points << @graph_left
            poly_points << @graph_bottom - 1
            @d.fill_opacity(0.3)
            @d = @d.polyline(*poly_points)
          end

          @d.draw(@base_image)
        end
      end
    end
  end # module MagickWrapper
end # module Rubyplot
