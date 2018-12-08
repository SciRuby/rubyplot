require_relative 'magick/draw'

require_relative 'artist/constants'
require_relative 'artist/attributes'
require_relative 'artist/geometry'
require_relative 'artist/math_methods'

# FIXME: formerly the scatter could take multiple 'data' calls but now takes only
# one.
module Rubyplot
  module MagickWrapper
    class Artist
      include Constants
      include Attributes
      include MathMethods
      include Magick
      
      # If one numerical argument is given, the graph is drawn at 4/3 ratio
      # according to the given width (800 results in 800x600, 400 gives 400x300,
      # etc.).
      #
      # Or, send a geometry string for other ratios ('800x400', '400x225').
      #
      # Looks for Bitstream Vera as the default font. Expects an environment var
      # of MAGICK_FONT_PATH to be set. (Uses RMagick's default font otherwise.)
      def initialize(axes, target_width = DEFAULT_TARGET_WIDTH)
        @axes = axes
        if Numeric === target_width
          @columns = target_width.to_f
          @rows = target_width.to_f * 0.75
        else
          geometric_width, geometric_height = target_width.split('x')
          @columns = geometric_width.to_f
          @rows = geometric_height.to_f
        end
        @geometry = Geometry.new
        initialize_variables

        reset_themes
        self.theme = Themes::CLASSIC_WHITE
      end

      def marker_size= marker_size
      end

      def marker_type= marker_type
      end

      # Set instance variables for this object.
      #
      # Subclasses can override this, call super, then set values separately.
      #
      # This makes it possible to set defaults in a subclass but still allow
      # developers to change the values in their program.
      def initialize_variables
        # Internal for calculations
        # FIXME: right now uses array of hashes for storing data. maybe
        # simply use multiple axes objects later?
        @data = {
          label: :default,
          color: :default
        }

        @raw_rows = 800.0 * (@rows / @columns)
        @sort = false
        @title_font = nil

        @scale = @columns / @geometry.raw_columns

        vera_font_path = File.expand_path('Vera.ttf', ENV['MAGICK_FONT_PATH'])
        @font = File.exist?(vera_font_path) ? vera_font_path : nil

        @marker_font_size = 21.0
        @legend_font_size = 20.0
        @title_font_size = 36.0

        @legend_margin = LEGEND_MARGIN

        @legend_box_size = 20.0

        @label_stagger_height = 0
        @label_max_size = 0
        @label_truncation_style = :absolute
        @plot_colors = []
      end

      def data(data_points = [], label: :default, color: :default)
        name = (label == :default) ? ' ' : label.to_s
        data_points = Array(data_points) # make sure it's an array
        # TODO: Adding an empty color array which can be developed later
        # to make graphs super customizable with regards to coloring of
        # individual data points.
        @data[:y_values] = data_points
        # Set column count if this is larger than previous column counts
        @geometry.column_count = data_points.length > @geometry.column_count ?
                                   data_points.length : @geometry.column_count

        # Pre-normalize => Set the max and min values of the data.
        data_points.each do |data_point|
          # Initialize the maximum and minimum values so that the spread starts
          # at the lowest points in the data and then changes as iteration.
          if @geometry.maximum_value.nil? && @geometry.minimum_value.nil?
            @geometry.maximum_value = @geometry.minimum_value = data_point
          end

          @geometry.maximum_value = data_point > @geometry.maximum_value ?
                                      data_point : @geometry.maximum_value
          @geometry.minimum_value = data_point < @geometry.minimum_value ?
                                      data_point : @geometry.minimum_value
          @geometry.has_data = true
        end
      end

      # You can set a theme manually. Assign a hash to this method before you
      # send your data. This permits you to set a background color and also
      # customize the background color to make it look prettier.
      # Aside from that we could also have a feature to draw on a background image
      # So later adding prebuilt background images to draw upon would also be
      # possible.
      #
      #  graph.theme = {
      #    :marker_color => 'blue',
      #    :background_colors => ['black', 'grey', :top_bottom]
      #  }
      #
      def theme=(options)
        reset_themes
        defaults = {
          marker_color: 'white',
          font_color: 'black',
          background_image: nil
        }
        @geometry.theme_options = defaults.merge options
        @marker_color = @geometry.theme_options[:marker_color]
        @font_color = @geometry.theme_options[:font_color] || @marker_color
        @base_image = render_gradiated_background(
          @geometry.theme_options[:background_colors][0],
          @geometry.theme_options[:background_colors][1],
          @geometry.theme_options[:background_direction])
      end

      # Resets the themes to defaults.
      def reset_themes
        @d = Magick::Draw.new
        # Scale down from defaut scale to scale used to calculate drawing.
        @d = @d.scale(@scale, @scale)
      end

      def scale(value)
        value * @scale
      end

      # Makes an array of colors randomly selected from all the possible list of
      # colors supported by RMagick. This function is used because it helps to decide
      # the colors for data labels if user doesn't specify the colors for data labels.
      def construct_colors_array
        return unless @plot_colors.empty?
        # 0.upto(@geometry.norm_data.size - 1) do |i|
          if (@data[:color] == :default)
            @plot_colors.push(@geometry.theme_options[:label_colors][0])
          else
            @plot_colors.push(Rubyplot::Color::COLOR_INDEX[@data[:color]])
          end
        # end
      end

      # Sets the colors for the data labels of the plot.
      def set_colors_array(color_array)
        @plot_colors = color_array
      end

      # Returns the current color array for the labels
      def get_colors_array
        @plot_colors
      end

      # Writes the plot to a file. Defaults to 'plot.png'
      # All file writing formats supported by RMagicks are supported by this
      # function.
      def write(filename = 'plot.png')
        draw
        @base_image.write(filename)
      end

      # Basic Rendering function that takes pre-processed input and plots it on
      # a figure canvas. This function only contains the generalized layout of a
      # plot. Based on individual cases the actual drawing function of a plot will
      # use super to call this method. And then draw upon the figure canvas.
      def draw
        artist_draw
      end

      # An alias to draw function to facilitate the ease of function calling
      # with subclasses used to define different plots.
      def artist_draw
        return unless @geometry.has_data
        setup_drawing
        construct_colors_array
        # ideal scenario should be to just instruct the backend to write
        # text at so-and-so place in some particular manner instead of specifically
        # legend and title etc.
        draw_legend!
        draw_line_markers!
        draw_title!
        draw_axis_labels!
      end

      ##
      # Calculates size of drawable area and generates normalized data.
      #
      # * line markers
      # * legend
      # * title
      # * labels
      # * X/Y offsets
      def setup_drawing
        calculate_spread
        normalize
        setup_graph_measurements
      end

      ##
      # Calculates size of drawable area, general font dimensions, etc.
      # This is the most crucial part of the code and is based on geometry.
      # It calcuates the measurments in pixels to figure out the positioning
      # gap pixels of Legends, Labels and Titles from the picture edge.
      def setup_graph_measurements
        @marker_caps_height = calculate_caps_height(@marker_font_size)

        @title_caps_height = @geometry.hide_title || @axes.title.nil? ? 0 :
                               calculate_caps_height(@title_font_size) * @axes.title.lines.to_a.size
        # Initially the title is nil.

        @legend_caps_height = calculate_caps_height(@legend_font_size)

        # For now, the labels feature only focuses on the dot graph so it
        # makes sense to only have this as an attribute for this kind of
        # graph and not for others.
        # FIXME: move this out of Artist.
        if @geometry.has_left_labels
          longest_left_label_width = calculate_width(
            @marker_font_size,
            @axes.y_ticks.values.inject('') { |value, memo|
              value.to_s.length > memo.to_s.length ? value : memo
            }) * 1.25
        else
          longest_left_label_width = calculate_width(
            @marker_font_size,
            label_string(@geometry.maximum_value.to_f, @geometry.increment))
        end

        # Shift graph if left line numbers are hidden
        line_number_width = @geometry.hide_line_numbers && !@geometry.has_left_labels ?
                              0.0 : (longest_left_label_width + LABEL_MARGIN * 2)

        # Pixel offset from the left edge of the plot
        @graph_left = @geometry.left_margin +
                      line_number_width +
                      (@geometry.y_axis_label .nil? ? 0.0 : @marker_caps_height + LABEL_MARGIN * 2)

        # Make space for half the width of the rightmost column label.
        last_label = @axes.x_ticks.keys.max.to_i
        extra_room_for_long_label = last_label >= (@geometry.column_count - 1) &&
                                    @geometry.center_labels_over_point ?
                                      calculate_width(@marker_font_size,
                                                      @axes.x_ticks[last_label]) / 2.0 : 0

        # Margins
        @graph_right_margin = @geometry.right_margin + extra_room_for_long_label
        @graph_bottom_margin = @geometry.bottom_margin + @marker_caps_height + LABEL_MARGIN

        @graph_right = @geometry.raw_columns - @graph_right_margin
        @graph_width = @geometry.raw_columns - @graph_left - @graph_right_margin

        # When @hide title, leave a title_margin space for aesthetics.
        @graph_top = @geometry.legend_at_bottom ?
                       @geometry.top_margin :
                       (@geometry.top_margin +
                        (@geometry.hide_title ?
                           @axes.title_margin :
                           @title_caps_height + @axes.title_margin) +
                        (@legend_caps_height + legend_margin))

        x_axis_label_height = @geometry.x_axis_label .nil? ? 0.0 :
                                @marker_caps_height + LABEL_MARGIN

        # The actual height of the graph inside the whole image in pixels.
        @graph_bottom = @raw_rows - @graph_bottom_margin - x_axis_label_height - @label_stagger_height
        @graph_height = @graph_bottom - @graph_top
      end

      # Draw the optional labels for the x axis and y axis.
      def draw_axis_labels!
        unless @geometry.x_axis_label.nil?
          # X Axis
          # Centered vertically and horizontally by setting the
          # height to 1.0 and the width to the width of the graph.
          x_axis_label_y_coordinate = @graph_bottom + LABEL_MARGIN * 2 + @marker_caps_height

          # TODO: Center between graph area
          @d.fill = @font_color
          @d.font = @font if @font
          @d.stroke('transparent')
          @d.pointsize = scale_fontsize(@marker_font_size)
          @d.gravity = NorthGravity
          @d = @d.scale_annotation(@base_image,
                                   @geometry.raw_columns, 1.0,
                                   0.0, x_axis_label_y_coordinate,
                                   @geometry.x_axis_label, @scale)
        end

        unless @geometry.y_axis_label .nil?
          # Y Axis, rotated vertically
          @d.rotation = -90.0
          @d.gravity = CenterGravity
          @d = @d.scale_annotation(@base_image,
                                   1.0, @raw_rows,
                                   @geometry.left_margin + @marker_caps_height / 2.0, 0.0,
                                   @geometry.y_axis_label, @scale)
          @d.rotation = 90.0
        end
      end

      # Draws a title on the graph.
      def draw_title!
        return if @geometry.hide_title || @axes.title.nil?

        @d.fill = @font_color
        @d.font = @title_font || @font if @title_font || @font
        @d.stroke('transparent')
        @d.pointsize = scale_fontsize(@title_font_size)
        @d.font_weight = BoldWeight
        @d.gravity = NorthGravity
        @d = @d.scale_annotation(@base_image,
                                 @geometry.raw_columns, 1.0,
                                 0, @geometry.top_margin,
                                 @axes.title, @scale)
      end

      ##
      # Draws a legend with the names of the datasets matched
      # to the colors used to draw them.
      def draw_legend!
        # FIXME: reflect single data behaviour
        @legend_labels = [@data[:label]]#@data.collect { |item| item[DATA_LABEL_INDEX] }

        legend_square_width = @legend_box_size # small square with color of this item

        # May fix legend drawing problem at small sizes
        @d.font = @font if @font
        @d.pointsize = @legend_font_size

        label_widths = [[]] # Used to calculate line wrap
        @legend_labels.each do |label|
          metrics = @d.get_type_metrics(@base_image, label.to_s)
          label_width = metrics.width + legend_square_width * 2.7
          label_widths.last.push label_width

          if sum(label_widths.last) > (@geometry.raw_columns * 0.9)
            label_widths.push [label_widths.last.pop]
          end
        end

        current_x_offset = center(sum(label_widths.first))
        current_y_offset = @geometry.legend_at_bottom ? @graph_height + @axes.title_margin : (
          @geometry.hide_title ? @geometry.top_margin + @axes.title_margin :
            @geometry.top_margin + @axes.title_margin + @title_caps_height)

        @legend_labels.each_with_index do |legend_label, _index|
          # Draw label
          @d.fill = @font_color
          @d.font = @font if @font
          @d.pointsize = scale_fontsize(@legend_font_size) # font size in points
          @d.stroke('transparent')
          @d.font_weight = NormalWeight
          @d.gravity = WestGravity
          @d = @d.scale_annotation(@base_image,
                                   @geometry.raw_columns, 1.0,
                                   current_x_offset + (legend_square_width * 1.7), current_y_offset,
                                   legend_label.to_s, @scale)

          # Now draw box with color of this dataset
          @d = @d.stroke('transparent')
          @d = @d.fill('black')
          @d = @d.fill(@plot_colors[_index]) if defined? @plot_colors
          @d = @d.rectangle(current_x_offset,
                            current_y_offset - legend_square_width / 2.0,
                            current_x_offset + legend_square_width,
                            current_y_offset + legend_square_width / 2.0)
          # string = 'hello' + _index.to_s + '.png'
          # @base_image.write(string)

          @d.pointsize = @legend_font_size
          metrics = @d.get_type_metrics(@base_image, legend_label.to_s)
          current_string_offset = metrics.width + (legend_square_width * 2.7)

          # Handle wrapping
          label_widths.first.shift
          if label_widths.first.empty?

            label_widths.shift
            current_x_offset = center(sum(label_widths.first)) unless label_widths.empty?
            line_height = [@legend_caps_height, legend_square_width].max + legend_margin
            unless label_widths.empty?
              # Wrap to next line and shrink available graph dimensions
              current_y_offset += line_height
              @graph_top += line_height
              @graph_height = @graph_bottom - @graph_top
            end
          else
            current_x_offset += current_string_offset
          end
        end
        @color_index = 0
      end

      # Draws horizontal background lines and labels
      def draw_line_markers!
        @d = @d.stroke_antialias false

        if @geometry.y_axis_increment .nil?
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
            @geometry.marker_count ||= 4
          end
          @geometry.increment = @spread > 0 && @geometry.marker_count > 0 ?
                                  significant(@spread / @geometry.marker_count) : 1
        else
          # TODO: Make this work for negative values
          @geometry.marker_count = (@spread / @geometry.y_axis_increment).to_i
          @geometry.increment = @geometry.y_axis_increment
        end
        @geometry.increment_scaled = @graph_height.to_f / (@spread / @geometry.increment)

        # Draw horizontal line markers and annotate with numbers
        (0..@geometry.marker_count).each do |index|
          y = @graph_top + @graph_height - index.to_f * @geometry.increment_scaled
          y_next = @graph_top + @graph_height - (index.to_f + 1) * @geometry.increment_scaled
         @d = @d.fill(@marker_color)
          @d = @d.line(@graph_left, y, @graph_right, y) if
            !@geometry.hide_line_markers || (index == 0)
          # If the user specified a marker shadow color, draw a shadow just below it
          unless @marker_shadow_color.nil?
            @d = @d.fill(@marker_shadow_color)
            @d = @d.line(@graph_left, y + 1, @graph_right, y + 1)
          end
          @d = @d.line(@graph_left, y + 1, @graph_left, y_next + 1)

          marker_label = BigDecimal(index.to_s) * BigDecimal(@geometry.increment.to_s) +
                         BigDecimal(@geometry.minimum_value.to_s)

          next if @geometry.hide_line_numbers
          @d.fill = @font_color
          @d.font = @font if @font
          @d.stroke('transparent')
          @d.pointsize = scale_fontsize(@marker_font_size)
          @d.gravity = EastGravity

          # Vertically center with 1.0 for the height
          @d = @d.scale_annotation(@base_image,
                                   @graph_left - LABEL_MARGIN, 1.0,
                                   0.0, y,
                                   label_string(marker_label, @geometry.increment), @scale)
        end
        @d = @d.stroke_antialias true
        # string = 'hello' + '.png'
        # @d.draw(@base_image)
        # @base_image.write(string)
      end

      # Use with a theme definition method to draw a gradiated background.
      def render_gradiated_background(top_color, bottom_color, direct = :top_bottom)
        gradient_fill = case direct
                        when :bottom_top
                          GradientFill.new(0, 0, 100, 0, bottom_color, top_color)
                        when :left_right
                          GradientFill.new(0, 0, 0, 100, top_color, bottom_color)
                        when :right_left
                          GradientFill.new(0, 0, 0, 100, bottom_color, top_color)
                        when :topleft_bottomright
                          GradientFill.new(0, 100, 100, 0, top_color, bottom_color)
                        when :topright_bottomleft
                          GradientFill.new(0, 0, 100, 100, bottom_color, top_color)
                        else
                          GradientFill.new(0, 0, 100, 0, top_color, bottom_color)
                        end
        Image.new(@columns, @rows, gradient_fill)
      end

      # Draws column labels below graph, centered over x_offset
      def draw_label(x_offset, index)
        if !@axes.x_ticks[index].nil? && @geometry.labels_seen[index].nil?
          y_offset = @graph_bottom + LABEL_MARGIN

          # TESTME
          # TODO: See if index.odd? is the best stragegy
          y_offset += @label_stagger_height if index.odd?

          label_text = @axes.x_ticks[index].to_s

          # TESTME
          # FIXME: Consider chart types other than bar
          if label_text.size > @label_max_size
            if @geometry.label_truncation_style == :trailing_dots
              if @label_max_size > 3
                # 4 because '...' takes up 3 chars
                label_text = "#{label_text[0..(@label_max_size - 4)]}..."
              end
            else # @geometry.label_truncation_style is :absolute (default)
              label_text = label_text[0..(@label_max_size - 1)]
            end

          end

          if x_offset >= @graph_left && x_offset <= @graph_right
            @d.fill = @font_color
            @d.font = @font if @font
            @d.stroke('transparent')
            @d.font_weight = NormalWeight
            @d.pointsize = scale_fontsize(@marker_font_size)
            @d.gravity = NorthGravity
            @d = @d.scale_annotation(@base_image,
                                     1.0, 1.0,
                                     x_offset, y_offset,
                                     label_text, @scale)
          end
          @geometry.labels_seen[index] = 1
        end
      end

      private

      # Return a formatted string representing a number value that should be
      # printed as a label.
      def label_string(value, increment)
        label =
          if increment
            if increment >= 10 || (increment * 1) == (increment * 1).to_i.to_f
              format('%0i', value)
            elsif increment >= 1.0 || (increment * 10) == (increment * 10).to_i.to_f
              format('%0.1f', value)
            elsif increment >= 0.1 || (increment * 100) == (increment * 100).to_i.to_f
              format('%0.2f', value)
            elsif increment >= 0.01 || (increment * 1000) == (increment * 1000).to_i.to_f
              format('%0.3f', value)
            elsif increment >= 0.001 || (increment * 10_000) == (increment * 10_000).to_i.to_f
              format('%0.4f', value)
            else
              value.to_s
            end
          elsif ((@spread.to_f %
                  (@geometry.marker_count.to_f == 0 ?
                     1 : @geometry.marker_count.to_f) == 0) ||
                 !@geometry.y_axis_increment .nil?)
            value.to_i.to_s
          elsif @spread > 10.0
            format('%0i', value)
          elsif @spread >= 3.0
            format('%0.2f', value)
          else
            value.to_s
          end
        parts = label.split('.')
        parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{THOUSAND_SEPARATOR}")
        parts.join('.')
      end
    end # class Artist
  end # module MagickWrapper
end # module Rubyplot
