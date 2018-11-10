require_relative 'stacked_bar/geometry'

module Rubyplot
  module MagickWrapper
    module Plot
      class StackedBar < Artist
        #DATA_VALUES_INDEX = Rubyplot::MagickArtist::DATA_VALUES_INDEX
        #
        # A stacked bar graph (or stacked bar chart) is a chart that uses bars to show
        # comparisons between categories of data, but with ability to break down and
        # compare parts of a whole. Each bar in the chart represents a whole, and
        # segments in the bar represent different parts or categories of that whole.
        #
        # ==== Example
        #
        # plot = Rubyplot::StackedBar.new(400)
        #
        # @datasets = [
        #   [:Car, [25, 36, 86, 39]],
        #   [:Bus, [80, 54, 67, 54]],
        #   [:Train, [22, 29, 35, 38]]
        # ]
        #
        # plot.title = 'Stacked Bar'
        # plot.labels = {
        #   0 => '10',
        #   1 => '15',
        #   2 => '20',
        #   3 => '30'
        # }
        # @datasets.each do |data|
        #   plot.data(data[0], data[1])
        # end
        # plot.write('stacked_bar.png')
        #
        def initialize(*)
          super
          @geometry = Plot::StackedBar::Geometry.new
        end

        def set_spacings
          # Setup spacing.
          #
          # Columns sit stacked.
          @bar_spacing ||= 0.9
          @segment_spacing ||= 1
          @bar_width = @graph_width / @geometry.column_count.to_f
          @padding = (@bar_width * (1 - @bar_spacing)) / 2
        end

        # Draws a bar graph, but multiple sets are stacked on top of each other.
        # Modified drawing feature of the bar graph with multiple bar graphs
        # stacked on top of each other.
        def draw
          max_stack_height
          artist_draw

          set_spacings
          @d = @d.stroke_opacity 0.0
          height = Array.new(@geometry.column_count, 0)

          @geometry.norm_data.each_with_index do |data_row, row_index|
            data_row[DATA_VALUES_INDEX].each_with_index do |data_point, point_index|
              @d = @d.fill @plot_colors[row_index]
              # Calculate center based on bar_width and current row
              label_center = @graph_left + (@bar_width * point_index) +
                             (@bar_width * @bar_spacing / 2.0)
              draw_label(label_center, point_index)

              next if data_point == 0
              # Use incremented x and scaled y
              left_x = @graph_left + (@bar_width * point_index) + @padding
              left_y = @graph_top + (@graph_height -
                                     data_point * @graph_height -
                                     height[point_index]) + @segment_spacing
              right_x = left_x + @bar_width * @bar_spacing
              right_y = @graph_top + @graph_height - height[point_index] - @segment_spacing

              # update the total height of the current stacked bar
              height[point_index] += (data_point * @graph_height)

              # Draw the rectangle
              @d = @d.rectangle(left_x, left_y, right_x, right_y)
            end
          end

          @d.draw(@base_image)
        end

        def max_stack_height
          # Get the sum of values in each stack to the get the stack height
          max_hash = {}
          #@data.each do |data_set|
            @data[:y_values].each_with_index do |data_point, i|
              max_hash[i] = 0.0 unless max_hash[i]
              max_hash[i] += data_point.to_f
            end
         # end

          @geometry.maximum_value = 0
          max_hash.keys.each do |key|
            @geometry.maximum_value = max_hash[key] if max_hash[key] > @geometry.maximum_value
          end
          @geometry.minimum_value = 0
        end
      end # class StackedBar
    end # module Plot
  end # module MagickWrapper
end # module Rubyplot
