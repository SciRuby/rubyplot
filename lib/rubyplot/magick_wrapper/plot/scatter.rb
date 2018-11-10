require_relative 'scatter/geometry'

module  Rubyplot
  module MagickWrapper
    module Plot
      class Scatter < Artist
        # Maximum X Value. The value will get overwritten by the max in the
        # datasets.
        attr_accessor :maximum_x_value

        # Minimum X Value. The value will get overwritten by the min in the
        # datasets.
        attr_accessor :minimum_x_value

        # The number of vertical lines shown for reference
        attr_accessor :marker_x_count

        # TODO: set a proper place for all the attributes.
        # ~ # Draw a dashed horizontal line at the given y value
        # ~ attr_accessor :baseline_y_value

        # ~ # Color of the horizontal baseline
        # ~ attr_accessor :baseline_y_color

        # ~ # Draw a dashed horizontal line at the given y value
        # ~ attr_accessor :baseline_x_value

        # ~ # Color of the horizontal baseline
        # ~ attr_accessor :baseline_x_color

        # Attributes to allow customising the size of the points
        attr_accessor :circle_radius
        attr_accessor :stroke_width

        # Allow disabling the significant rounding when labeling the X axis
        # This is useful when working with a small range of high values (for example, a date range of months, while seconds as units)
        attr_accessor :disable_significant_rounding_x_axis

        # Allow enabling vertical lines. When you have a lot of data, they can work great
        attr_accessor :enable_vertical_line_markers

        # Allow using vertical labels in the X axis (and setting the label margin)
        attr_accessor :x_label_margin
        attr_accessor :use_vertical_x_labels

        # Allow passing lambdas to format labels
        attr_accessor :y_axis_label_format
        attr_accessor :x_axis_label_format

        # Rubyplot::Scatter takes the same parameters as the Rubyplot::Line graph
        #
        # ==== Example
        #
        # g = Rubyplot::Scatter.new
        #
        def initialize(*)
          super
          @geometry = Rubyplot::MagickWrapper::Plot::Scatter::Geometry.new
        end

        def setup_drawing
          @labels = {}
          super
          # Translate our values so that we can use the base methods for drawing
          # the standard chart stuff
          @geometry.column_count = @x_spread
        end

        # OUTDATED DOCS.
        # The first parameter is the name of the dataset.  The next two are the
        # x and y axis data points contain in their own array in that respective
        # order.  The final parameter is the color.
        #
        # Can be called multiple times with different datasets for a multi-valued
        # graph.
        #
        # If the color argument is nil, the next color from the default theme will
        # be used.
        #
        # ==== Parameters
        # name:: String or Symbol containing the name of the dataset.
        # x_data_points:: An Array of of x-axis data points.
        # y_data_points:: An Array of of y-axis data points.
        # color:: The hex string for the color of the dataset.  Defaults to nil.
        #
        # ==== Exceptions
        # Data points contain nil values::
        #   This error will get raised if either the x or y axis data points array
        #   contains a <tt>nil</tt> value.  The graph will not make an assumption
        #   as how to graph <tt>nil</tt>
        # x_data_points is empty::
        #   This error is raised when the array for the x-axis points are empty
        # y_data_points is empty::
        #   This error is raised when the array for the y-axis points are empty
        # x_data_points.length != y_data_points.length::
        #   Error means that the x and y axis point arrays do not match in length
        #
        #
        def data(x_data_points = [], y_data_points = [], label: :default, color: :default)
          # Call the existing data routine for the y axis data
          super(y_data_points, label: label, color: color)

          # append the x data to the last entry that was just added in the @data member
          @data[:x_values] = x_data_points

          if @geometry.maximum_x_value.nil? && @geometry.minimum_x_value.nil?
            @geometry.maximum_x_value = @geometry.minimum_x_value = x_data_points.first
          end

          @geometry.maximum_x_value = x_data_points.max > @geometry.maximum_x_value ?
                                        x_data_points.max : @geometry.maximum_x_value
          @geometry.minimum_x_value = x_data_points.min < @geometry.minimum_x_value ?
                                        x_data_points.min : @geometry.minimum_x_value
        end

        def calculate_spread #:nodoc:
          super
          @x_spread = @geometry.maximum_x_value.to_f - @geometry.minimum_x_value.to_f
          @x_spread = @x_spread > 0 ? @x_spread : 1
        end

        # FIXME: eventually move this normalization to Axes.
        def normalize(force = nil)
          if @geometry.norm_data.nil? || force
            @geometry.norm_data = []
            return unless @geometry.has_data

            data_row = @data
            norm_data_points = [data_row[:label]]
            norm_data_points << data_row[:y_values].map do |r|
              (r.to_f - @geometry.minimum_value.to_f) / @spread
            end

            norm_data_points << data_row[:color]
            norm_data_points << data_row[:x_values].map do |r|
              (r.to_f - @geometry.minimum_x_value.to_f) / @x_spread
            end
            @geometry.norm_data << norm_data_points
          end
        end

        def draw
          super
          return unless @geometry.has_data

          # Check to see if more than one datapoint was given. NaN can result otherwise.
          @x_increment = @geometry.column_count > 1 ?
                           (@graph_width / (@geometry.column_count - 1).to_f) : @graph_width

          @geometry.norm_data.each_with_index do |data_row, row_num|
            data_row[DATA_VALUES_INDEX].each_with_index do |data_point, index|
              @d = @d.fill @plot_colors[row_num]
              x_value = data_row[DATA_VALUES_X_INDEX][index]
              next if data_point.nil? || x_value.nil?

              new_x = get_x_coord(x_value, @graph_width, @graph_left)
              new_y = @graph_top + (@graph_height - data_point * @graph_height)

              # Reset each time to avoid thin-line errors
              @d = @d.stroke_opacity 1.0
              @d = @d.stroke_width(@geometry.stroke_width ||
                                   clip_value_if_greater_than(
                                     @columns / (
                                       @geometry.norm_data.first[1].size * 4), 5.0))

              circle_radius = @geometry.circle_radius ||
                              clip_value_if_greater_than(
                                @columns / (@geometry.norm_data.first[1].size * 2.5), 5.0)
              @d = @d.circle(new_x, new_y, new_x - circle_radius, new_y)
            end
          end

          @d.draw(@base_image)
        end

        protected

        def draw_line_markers!
          # do all of the stuff for the horizontal lines on the y-axis
          super
          return if @geometry.hide_line_markers
          @d = @d.stroke_antialias false

          if @geometry.x_axis_increment.nil?
            # TODO: Do the same for larger numbers...100, 75, 50, 25
            if @geometry.marker_x_count.nil?
              (3..7).each do |lines|
                if @x_spread % lines == 0.0
                  @geometry.marker_x_count = lines
                  break
                end
              end
              @geometry.marker_x_count ||= 4
            end
            @x_increment = @x_spread > 0 ? (@x_spread / @geometry.marker_x_count) : 1
            unless @geometry.disable_significant_rounding_x_axis
              @x_increment = significant(@x_increment)
            end
          else
            # TODO: Make this work for negative values
            @geometry.maximum_x_value = [@geometry.maximum_value.ceil, @geometry.x_axis_increment].max
            @geometry.minimum_x_value = @geometry.minimum_x_value.floor
            calculate_spread
            normalize(true)

            @geometry.marker_count = (@x_spread / @geometry.x_axis_increment).to_i
            @x_increment = @geometry.x_axis_increment
          end
          @geometry.increment_x_scaled = @graph_width.to_f / (@x_spread / @x_increment)

          # Draw vertical line markers and annotate with numbers
          (0..@geometry.marker_x_count).each do |index|
            # TODO: Fix the vertical lines, and enable them by default. Not pretty when they don't match up with top y-axis line
            if @geometry.enable_vertical_line_markers
              x = @graph_left + @graph_width - index.to_f * @geometry.increment_x_scaled
              @d = @d.stroke(@marker_color)
              @d = @d.stroke_width 1
              @d = @d.line(x, @graph_top, x, @graph_bottom)
            end

            next if @geometry.hide_line_numbers
            marker_label = index * @x_increment + @geometry.minimum_x_value.to_f
            y_offset = @graph_bottom + (@geometry.x_label_margin || LABEL_MARGIN)
            x_offset = get_x_coord(index.to_f, @geometry.increment_x_scaled, @graph_left)

            @d.fill = @font_color
            @d.font = @font if @font
            @d.stroke('transparent')
            @d.pointsize = scale_fontsize(@marker_font_size)
            @d.gravity = NorthGravity
            @d.rotation = -90.0 if @geometry.use_vertical_x_labels
            @d = @d.scale_annotation(@base_image,
                                     1.0, 1.0,
                                     x_offset, y_offset,
                                     vertical_label(marker_label, @x_increment), @scale)
            @d.rotation = 90.0 if @geometry.use_vertical_x_labels
          end

          @d = @d.stroke_antialias true
        end

        def label_string(value, increment)
          if @geometry.y_axis_label_format
            @geometry.y_axis_label_format.call(value)
          else
            super
          end
        end

        def vertical_label(value, increment)
          if @geometry.x_axis_label_format
            @geometry.x_axis_label_format.call(value)
          else
            label_string(value, increment)
          end
        end

        private

        def get_x_coord(x_data_point, width, offset)
          x_data_point * width + offset
        end
      end
    end
  end
end
