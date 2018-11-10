require_relative 'line/geometry'

# This module offers different rendering option for data points
# to be used with line graph. For now we have circle and square as choices.
# FIXME: refactor this module and make it a part of Line.
module DotRenderers
  class Circle
    def render(d, new_x, new_y, circle_radius)
      d.circle(new_x, new_y, new_x - circle_radius, new_y)
    end
  end

  class Square
    def render(d, new_x, new_y, circle_radius)
      offset = (circle_radius * 0.8).to_i
      corner_1 = new_x - offset
      corner_2 = new_y - offset
      corner_3 = new_x + offset
      corner_4 = new_y + offset
      d.rectangle(corner_1, corner_2, corner_3, corner_4)
    end
  end

  def self.renderer(style)
    if style.to_s == 'square'
      Square.new
    else
      Circle.new
    end
  end
end

module Rubyplot
  module MagickWrapper
    module Plot
      class Line < Artist
        # Dimensions of lines and dots; calculated based on dataset size if left unspecified
        attr_accessor :line_width
        attr_accessor :dot_radius
        # Call with target pixel width of graph (800, 400, 300), and/or
        #   'false' to omit lines (points only).
        #  g = Rubyplot::Line.new(400) # 400px wide with lines.
        #
        #  g = Rubyplot::Line.new(400, false) # 400px wide, no lines
        #
        #  g = Rubyplot::Line.new(false) # Defaults to 800px wide, no lines
        def initialize(*args)
          raise ArgumentError, 'Wrong number of arguments' if args.length > 2
          if args.empty? || (!(Numeric === args.first) && !(String === args.first))
            super
          else
            super args.shift # TODO: Figure out a better alternative here.
          end

          @geometry = Plot::Line::Geometry.new
        end

        # Get the value if somebody has defined it.
        def baseline_value
          @geometry.reference_lines[:baseline][:value] if @geometry.reference_lines.key?(:baseline)
        end

        # Set a value for a baseline reference line.
        def baseline_value=(new_value)
          @geometry.reference_lines[:baseline] ||= {}
          @geometry.reference_lines[:baseline][:value] = new_value
        end

        def draw_reference_line(reference_line, left, right, top, bottom)
          @d = @d.push
          @d.stroke_color(@reference_line_default_color)
          @d.fill_opacity 0.0
          @d.stroke_dasharray(10, 20)
          @d.stroke_width(reference_line[:width] || @reference_line_default_width)
          @d.line(left, top, right, bottom)
          @d = @d.pop
        end

        def draw
          super
          return unless @geometry.has_data

          # Check to see if more than one datapoint was given. NaN can result otherwise.
          @x_increment = @geometry.column_count > 1 ?
                           (@graph_width / (@geometry.column_count - 1).to_f) : @graph_width

          @geometry.norm_data.each_with_index do |data_row, row_num|
            # Initially the previous x,y points are nil and then
            # they are set with values.
            prev_x = prev_y = nil

            @one_point = contains_one_point_only?(data_row)

            @d = @d.fill @plot_colors[row_num]
            data_row[DATA_VALUES_INDEX].each_with_index do |data_point, index|
              x_data = data_row[DATA_VALUES_X_INDEX]
              if x_data.nil?
                new_x = @graph_left + (@x_increment * index)
                draw_label(new_x, index)
              else
                new_x = get_x_coord(x_data[index], @graph_width, @graph_left)
                @labels.each do |label_pos, _|
                  draw_label(@graph_left + ((label_pos -
                                             @geometry.minimum_x_value) *
                                            @graph_width) /
                                           (@geometry.maximum_x_value -
                                            @geometry.minimum_x_value), label_pos)
                end
              end
              unless data_point
                # we can't draw a line for a null data point, we can still label the axis though
                prev_x = prev_y = nil
                next
              end
              new_y = @graph_top + (@graph_height - data_point * @graph_height)
              # Reset each time to avoid thin-line errors.
              #  @d = @d.stroke data_row[DATA_COLOR_INDEX]
              # @d = @d.fill data_row[DATA_COLOR_INDEX]
              @d = @d.stroke_opacity 1.0
              @d = @d.stroke_width line_width ||
                                   clip_value_if_greater_than(@columns / (@geometry.norm_data.first[DATA_VALUES_INDEX].size * 4), 5.0)

              circle_radius = dot_radius ||
                              clip_value_if_greater_than(@columns / (@geometry.norm_data.first[DATA_VALUES_INDEX].size * 2.5), 5.0)

              if !@geometry.hide_lines && !prev_x.nil? && !prev_y.nil?
                @d = @d.line(prev_x, prev_y, new_x, new_y)
              elsif @one_point
                # Show a circle if there's just one_point
                @d = DotRenderers.renderer(@geometry.dot_style).render(@d, new_x, new_y, circle_radius)
              end

              unless @geometry.hide_dots
                @d = DotRenderers.renderer(@geometry.dot_style).render(@d, new_x, new_y, circle_radius)
              end

              prev_x = new_x
              prev_y = new_y
            end
          end

          @d.draw(@base_image)
        end

        # Returns the X co-ordinate of a given data point.
        def get_x_coord(x_data_point, width, offset)
          x_data_point * width + offset
        end

        # This method allows one to plot a dataset with both X and Y data.
        #
        # Parameters:
        #   name: string, the title of the datasets.
        #   x_data_points: an array containing the x data points for the graph.
        #   y_data_points: an array containing the y data points for the graph.
        #
        #   or
        #
        #   name: string, the title of the dataset.
        #   xy_data_points: an array containing both x and y data points for the graph.
        #
        #
        #  Notes:
        #   -if (x_data_points.length != y_data_points.length) an error is
        #     returned.
        #   -if you want to use a preset theme, you must set it before calling
        #     dataxy().
        #
        # Example:
        #   g = Rubyplot::Line.new
        #   g.title = "X/Y Dataset"
        #   g.dataxy("Apples", [1,3,4,5,6,10], [1, 2, 3, 4, 4, 3])
        #   g.dataxy("Bapples", [1,3,4,5,7,9], [1, 1, 2, 2, 3, 3])
        #   g.dataxy("Capples", [[1,1],[2,3],[3,4],[4,5],[5,7],[6,9]])
        #   #you can still use the old data method too if you want:
        #   g.data("Capples", [1, 1, 2, 2, 3, 3])
        #   #labels will be drawn at the x locations of the keys passed in.
        #   In this example the lables are drawn at x positions 2, 4, and 6:
        #   g.labels = {0 => '2003', 2 => '2004', 4 => '2005', 6 => '2006'}
        #   The 0 => '2003' label will be ignored since it is outside the chart range.
        def dataxy(_name, x_data_points = [], y_data_points = [], _color = nil)
          raise ArgumentError, 'x_data_points is nil!' if x_data_points.empty?

          if x_data_points.all? { |p| p.is_a?(Array) && p.size == 2 }
            y_data_points = x_data_points.map { |p| p[1] }
            x_data_points = x_data_points.map { |p| p[0] }
          end

          raise ArgumentError, 'x_data_points.length != y_data_points.length!' if
            x_data_points.length != y_data_points.length

          # call the existing data routine for the y data.
          data(y_data_points, label: :name)

          x_data_points = Array(x_data_points) # make sure it's an array
          # append the x data to the last entry that was just added in the @data member
          @data.last[DATA_VALUES_X_INDEX] = x_data_points

          # Update the global min/max values for the x data
          x_data_points.each do |x_data_point|
            next if x_data_point.nil?

            # Setup max/min so spread starts at the low end of the data points
            if @geometry.maximum_x_value.nil? && @geometry.minimum_x_value.nil?
              @geometry.maximum_x_value = @geometry.minimum_x_value = x_data_point
            end

            @geometry.maximum_x_value = x_data_point > @geometry.maximum_x_value ?
                                          x_data_point : @geometry.maximum_x_value
            @geometry.minimum_x_value = x_data_point < @geometry.minimum_x_value ?
                                          x_data_point : @geometry.minimum_x_value
          end
        end

        def normalize
          # First call the standard math function to normalize the values based on spread.
          super
          # TODO: Take care of the reference_lines

          # normalize the x data if it is specified
          @data.each_with_index do |data_row, index|
            norm_x_data_points = []
            next if data_row[DATA_VALUES_X_INDEX].nil?
            data_row[DATA_VALUES_X_INDEX].each do |x_data_point|
              norm_x_data_points << ((x_data_point.to_f -
                                      @geometry.minimum_x_value.to_f) /
                                     (@geometry.maximum_x_value.to_f -
                                      @geometry.minimum_x_value.to_f))
            end
            @geometry.norm_data[index] << norm_x_data_points
          end
        end

        def sort_norm_data
          super unless @data.any? { |d| d[DATA_VALUES_X_INDEX] }
        end

        def contains_one_point_only?(data_row)
          # A helper function that acts as a sanity check for the data.
          # It spins through data to determine if there is just one_value present.
          one_point = false
          data_row[DATA_VALUES_INDEX].each do |data_point|
            next if data_point.nil?
            if one_point
              # more than one point, bail
              return false
            end
            # there is at least one data point
            one_point = true
          end
          one_point
        end
      end
    end
  end
end
