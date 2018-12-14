module Rubyplot
  module MagickWrapper
    module Plot
      class Dot < Artist
        def draw
          @geometry.has_left_labels = true
          super
          return unless @geometry.has_data

          # Setup spacing.
          spacing_factor = 1.0
          @items_width = @graph_height / @geometry.column_count.to_f
          @item_width = @items_width * spacing_factor / @geometry.norm_data.size
          @d = @d.stroke_opacity 0.0
          padding = (@items_width * (1 - spacing_factor)) / 2

          @geometry.norm_data.each_with_index do |data_row, row_index|
            data_row[DATA_VALUES_INDEX].each_with_index do |data_point, point_index|
              x_pos = @graph_left + (data_point * @graph_width)
              y_pos = @graph_top + (@items_width * point_index) +
                      padding + (@items_width.to_f / 2.0).round

              if row_index.zero?
                @d = @d.stroke(@marker_color)
                @d = @d.fill(@marker_color)
                @d = @d.stroke_width 1.0
                @d = @d.stroke_opacity 0.1
                @d = @d.fill_opacity 0.1
                @d = @d.line(@graph_left, y_pos, @graph_left + @graph_width, y_pos)
                @d = @d.fill_opacity 1
              end

              @d = @d.fill @plot_colors[row_index]
              @d = @d.circle(x_pos, y_pos, x_pos + (@item_width.to_f / 3.0).round, y_pos)
              draw_label(y_pos, point_index)
            end
          end
          @d.draw(@base_image)
        end

        # Instead of base class version, draws vertical background lines and label
        def draw_line_markers
          @d = @d.stroke_antialias false

          # Draw horizontal line markers and annotate with numbers
          @d = @d.stroke(@marker_color)
          @d = @d.stroke_width 1
          if @y_axis_increment
            increment = @y_axis_increment
            number_of_lines = (@spread / @y_axis_increment).to_i
          else
            # Try to use a number of horizontal lines that will come out even.
            #
            # TODO Do the same for larger numbers...100, 75, 50, 25
            if @geometry.marker_count.nil?
              (3..7).each do |lines|
                if @spread % lines == 0.0
                  @geometry.marker_count = lines
                  break
                end
              end
              @geometry.marker_count ||= 5
            end
            # TODO: Round maximum marker value to a round number like 100, 0.1, 0.5, etc.
            @geometry.increment = if @spread > 0 && @geometry.marker_count > 0
                                    significant(@spread / @geometry.marker_count)
                                  else 1
                                  end

            number_of_lines = @geometry.marker_count
            increment = @geometry.increment
          end

          (0..number_of_lines).each do |index|
            marker_label = @geometry.minimum_value + index * increment
            x = @graph_left + (marker_label - @geometry.minimum_value) * @graph_width / @spread
            @d = @d.line(x, @graph_bottom, x, @graph_bottom + 0.5 * LABEL_MARGIN)

            unless @geometry.hide_line_numbers
              @d.fill = @font_color
              @d.font = @font if @font
              @d.stroke = 'transparent'
              @d.pointsize = scale_fontsize(@marker_font_size)
              @d.gravity = CenterGravity
              # TODO: Center text over line
              @d = @d.scale_annotation(@base_image,
                0, 0, # Width of box to draw text in
                x, @graph_bottom + (LABEL_MARGIN * 2.0), # Coordinates of text
                label(marker_label, increment), @scale)
            end
            # unless
            @d = @d.stroke_antialias true
          end
        end

        # Draw on the Y axis instead of the X
        def draw_label(y_offset, index)
          if !@axes.y_ticks[index].nil? && @geometry.labels_seen[index].nil?
            @d.fill = @font_color
            @d.font = @font if @font
            @d.stroke = 'transparent'
            @d.font_weight = NormalWeight
            @d.pointsize = scale_fontsize(@marker_font_size)
            @d.gravity = EastGravity
            @d = @d.scale_annotation(@base_image,
              1, 1,
              -@graph_left + LABEL_MARGIN * 2.0, y_offset,
              @axes.y_ticks[index], @scale)
            @geometry.labels_seen[index] = 1
          end
        end
      end
      # class Dot
    end
    # module Plot
  end
  # module MagickWrapper
end
# module Rubyplot
