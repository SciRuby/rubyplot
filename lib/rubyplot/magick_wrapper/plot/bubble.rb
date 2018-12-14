require_relative 'bubble/geometry'

module Rubyplot
  module MagickWrapper
    module Plot
      class Bubble < MagickWrapper::Plot::Scatter
        # Rubyplot::Bubble takes the same parameters as the Rubyplot::Bubble graph
        #
        # ==== Example
        # g = Rubyplot::Bubble.new
        #
        def initialize(*)
          super
          @all_colors_array = Magick.colors
          @plot_colors = []
          @z_data = []
          @geometry = Plot::Bubble::Geometry.new
        end

        # The first parameter is the name of the dataset.  The next two are the
        # x and y axis data points contain in their own array in that respective
        # order. Then the Z axis data points refer to the radius of the bubble plots.
        # The final parameter is the color.
        #
        # Can be called multiple times with different datasets for a multi-valued
        # graph.
        #
        # If the color argument is nil, the next color from the default theme will
        # be used.
        #
        # ==== Parameters to data function
        # name:: String or Symbol containing the name of the dataset.
        # x_data_points:: An Array of x-axis data points.
        # y_data_points:: An Array of y-axis data points.
        # z_data_points:: An Array containing the radius of the data points.
        # color:: The hex string for the color of the dataset.  Defaults to nil.
        #
        #
        # ==== Examples
        # plot = Rubyplot::Bubble.new
        # plot.data(:apples, [-1, 19, -4, -23], [-35, 21, 23, -4], [45, 10, 21, 9])
        # plot.data(:peaches, [20, 30, -6, -3], [-1, 5, -27, -3], [13, 10, 20, 10])
        # plot.write('spec/reference_images/bubble_test_1.png')
        #
        def data(x_data_points=[], y_data_points=[], z_data_points=[])
          #          name = label == :default ? ' ' : label.to_s
          #  the existing data routine for the y axis data
          data_y(y_data_points, z_data_points)
          # append the x data to the last entry that was just added in the @data member
          # last_elem = @data.length - 1
          # @data[last_elem] << x_data_points
          @data[:x_values] = x_data_points

          if @geometry.max_x_value.nil? && @geometry.min_x_value.nil?
            @geometry.max_x_value = @geometry.min_x_value = x_data_points.first
          end
          @z_data << z_data_points
          x_z_array_sum = [x_data_points, z_data_points].transpose.map { |x| x.reduce(:+) }
          x_z_array_dif = [x_data_points, z_data_points].transpose.map { |x| x.reduce(:-) }

          @geometry.max_x_value = x_z_array_sum.max > @geometry.max_x_value ? x_z_array_sum.max : @geometry.max_x_value
          @geometry.min_x_value = x_z_array_sum.min < @geometry.min_x_value ? x_z_array_sum.min : @geometry.min_x_value
          @geometry.max_x_value = x_z_array_dif.max > @geometry.max_x_value ? x_z_array_dif.max : @geometry.max_x_value
          @geometry.min_x_value = x_z_array_dif.min < @geometry.min_x_value ? x_z_array_dif.min : @geometry.min_x_value
        end

        private

        # Helper function to normalize the data along Y axis.
        def data_y(z_data_points, data_points=[])
          data_points = Array(data_points) # make sure it's an array
          # TODO: Adding an empty color array which can be developed later to make graphs
          # super customizable with regards to coloring of individual data points.
          @data[:y_values] = data_points
          # Set column count if this is larger than previous column counts
          @geometry.column_count = if data_points.length > @geometry.column_count then data_points.length
                                   else @geometry.column_count
                                   end

          y_z_array_sum = [data_points, z_data_points].transpose.map { |x| x.reduce(:+) }
          y_z_array_dif = [data_points, z_data_points].transpose.map { |x| x.reduce(:-) }
          if @geometry.maximum_value.nil? && @geometry.maximum_value.nil?
            @geometry.maximum_value = @geometry.minimum_value = data_points.first
          end
          @geometry.maximum_value = if y_z_array_sum.max > @geometry.maximum_value then y_z_array_sum.max
                                    else @geometry.maximum_value
                                    end
          @geometry.minimum_value = if y_z_array_sum.min < @geometry.minimum_value then y_z_array_sum.min
                                    else @geometry.minimum_value
                                    end
          @geometry.maximum_value = if y_z_array_dif.max > @geometry.maximum_value then y_z_array_dif.max
                                    else @geometry.maximum_value
                                    end
          @geometry.minimum_value = if y_z_array_dif.min < @geometry.minimum_value then y_z_array_dif.min
                                    else @geometry.minimum_value
                                    end
          @geometry.has_data = true
        end

        def draw
          super
          # Check to see if more than one datapoint was given. NaN can result otherwise.
          @x_increment = @geometry.column_count > 1 ? (@graph_width / (@geometry.column_count - 1).to_f) : @graph_width

          @geometry.norm_data.each_with_index do |data_row, data_row_index|
            data_row[DATA_VALUES_INDEX].each_with_index do |data_point, index|
              @d = @d.fill @plot_colors[data_row_index]
              x_value = data_row[DATA_VALUES_X_INDEX][index]
              next if data_point.nil? || x_value.nil?

              new_x = get_x_coord(x_value, @graph_width, @graph_left)
              new_y = @graph_top + (@graph_height - data_point * @graph_height)

              # Reset each time to avoid thin-line errors
              @d = @d.stroke_opacity 1.0
              @d.fill_opacity(0.3)
              @d.fill_color(@plot_colors[data_row_index])
              @d = @d.stroke_width @stroke_width ||
                                   clip_value_if_greater_than(@columns /
                                                              (@geometry.norm_data.first[1].size * 4), 5.0)
              circle_radius = 2 * @z_data[data_row_index][index]
              @d = @d.circle(new_x, new_y, new_x - circle_radius, new_y)
            end
          end
          @d.draw(@base_image)
        end
      end
      # class Bubble
    end
    # module Plot
  end
  # module MagickWrapper
end
# module Rubyplot
