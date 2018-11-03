require_relative 'bar/geometry'

module Rubyplot
  module MagickWrapper
    module Plot
      class Bar < Artist
        # Spacing factor applied between bars
        attr_accessor :bar_spacing

        # needed for Y co-ordinate conversion. FIXME: refactor this.
        attr_writer :mode
        attr_writer :zero
        attr_writer :graph_top
        attr_writer :graph_height
        attr_writer :minimum_value
        attr_writer :spread

        def initialize(*args)
          super
          @geometry = Plot::Bar::Geometry.new
        end

        def draw
          # Labels will be centered over the left of the bar if
          # there are more labels than columns. This is basically the same
          # as where it would be for a line graph.
          @geometry.center_labels_over_point = (@axes.x_ticks.keys.length > @geometry.column_count)
          super
          return unless @geometry.has_data
          draw_bars
        end

        # Can be used to adjust the spaces between the bars.
        # Accepts values between 0.00 and 1.00 where 0.00 means no spacing at all
        # and 1 means that each bars' width is nearly 0 (so each bar is a simple
        # line with no x dimension).
        #
        # Default value is 0.9.
        def spacing_factor=(space_percent)
          raise ArgumentError, 'geometry.spacing_factor must be between 0.00 and 1.00' unless
            (space_percent >= 0) && (space_percent <= 1)
          @geometry.spacing_factor = (1 - space_percent)
        end

        def draw_bars
          # Setup spacing.
          #
          # Columns sit side-by-side.
          @bar_spacing ||= @geometry.spacing_factor # space between the bars
          @bar_width = @graph_width / (@geometry.column_count * @data.length).to_f
          padding = (@bar_width * (1 - @bar_spacing)) / 2

          @d = @d.stroke_opacity 0.0

          # Setup the BarConversion Object
          @graph_height = @graph_height
          @graph_top = @graph_top

          # Set up the right mode [1,2,3] see BarConversion for further explanation
          if @geometry.minimum_value >= 0
            # all bars go from zero to positiv
            @mode = :positive
          else
            # all bars go from 0 to negativ
            if @geometry.maximum_value <= 0
              @mode = :negative
            else
              # bars either go from zero to negativ or to positive
              @mode = :both
              @spread = @spread
              @minimum_value = @geometry.minimum_value
              @zero = -@geometry.minimum_value / @spread
            end
          end

          # iterate over all normalised data
          @geometry.norm_data.each_with_index do |data_row, row_index|
            data_row[DATA_VALUES_INDEX].each_with_index do |data_point, point_index|
              @d = @d.fill @plot_colors[row_index]
              # Use incremented x and scaled y
              # x
              left_x = @graph_left + (
                @bar_width *
                (row_index + point_index + ((@data.length - 1) * point_index))) + padding
              right_x = left_x + @bar_width * @bar_spacing
              # y
              conv = []
              get_left_y_right_y_scaled(data_point, conv)

              # create new bar
              @d = @d.rectangle(left_x, conv[0], right_x, conv[1])

              # Calculate center based on bar_width and current row
              label_center = @graph_left +
                             (@data.length * @bar_width * point_index) +
                             (@data.length * @bar_width / 2.0)

              # Subtract half a bar width to center left if requested
              draw_label(label_center -
                         (@geometry.center_labels_over_point ? @bar_width / 2.0 : 0.0),
                         point_index)
              if @geometry.show_labels_for_bar_values
                val = (@geometry.label_formatting || '%.2f') %
                      @geometry.norm_data[row_index][3][point_index]
                draw_value_label(left_x + (right_x - left_x) / 2, conv[0] - 30, val.commify, true)
              end
            end
          end

          # Draw the last label if requested
          draw_label(@graph_right, @geometry.column_count) if @geometry.center_labels_over_point
          @d.draw(@base_image)
        end
        
        def get_left_y_right_y_scaled(data_point, result)
          case @mode
          when :positive then # Case one
            # minimum value >= 0 ( only positiv values ) -> all the bars go in the +ve direction
            result[0] = @graph_top + @graph_height * (1 - data_point) + 1
            result[1] = @graph_top + @graph_height - 1
          when :negative then # Case two
            # only negative values -> all the bars go in the -ve direction
            result[0] = @graph_top + 1
            result[1] = @graph_top + @graph_height * (1 - data_point) - 1
          when :both then # Case three
            # positive and negative values -> bars go in both the +ve and -ve direction
            val = data_point - @geometry.minimum_value / @spread
            if data_point >= @zero
              result[0] = @graph_top + @graph_height * (1 - (val - @zero)) + 1
              result[1] = @graph_top + @graph_height * (1 - @zero) - 1
            else
              result[0] = @graph_top + @graph_height * (1 - (val - @zero)) + 1
              result[1] = @graph_top + @graph_height * (1 - @zero) - 1
            end
          else
            result[0] = 0.0
            result[1] = 0.0
          end
        end
      end # class Bar
    end # module Plot
  end # module MagickWrapper
end # module Rubyplot
