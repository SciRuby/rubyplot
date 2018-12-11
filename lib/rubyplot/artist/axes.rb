module Rubyplot
  module Artist
    class Axes < Base
      TITLE_MARGIN = 20.0
      # Space around text elements. Mostly used for vertical spacing.
      # This way the vertical text doesn't overlap.
      LEGEND_MARGIN = TITLE_MARGIN = 20.0
      LABEL_MARGIN = 10.0
      DEFAULT_MARGIN = 20.0

      THOUSAND_SEPARATOR = ','.freeze

      # FIXME: most of the below accessors should just be name= methods which
      # will access the required Artist and set the variable in there directly.
      # Title of the X axis
      attr_accessor :x_title
      # Title of the Y axis.
      attr_accessor :y_title
      # Range of X axis.
      attr_accessor :x_range
      # Range of Y axis.
      attr_accessor :y_range,
                    :x_tick_count, :y_tick_count, :text_font, :grid,
                    :bounding_box, :x_axis_padding, :y_axis_padding, :origin,
                    :title_shift, :title_margin

      # A hash of names for the individual columns, where the key is the array
      # index for the column this label represents.
      #
      # Not all columns need to be named.
      #
      # Example: 0 => 2005, 3 => 2006, 5 => 2007, 7 => 2008
      attr_accessor :x_ticks
      attr_accessor :y_ticks
      # Main title for this Axes.
      attr_accessor :title
      # Rubyplot::Figure object to which this Axes belongs.
      attr_reader :figure
      # Array of plots contained in this Axes.
      attr_reader :plots
      # data variables for something
      attr_reader :raw_rows

      attr_reader :geometry, :font, :marker_font_size, :legend_font_size,
                  :title_font_size, :scale, :font_color, :marker_color, :axes,
                  :legend_margin, :backend, :marker_caps_height, :marker_font_size
      
      attr_reader :label_stagger_height
      # FIXME: possibly disposable attrs
      attr_reader :title_caps_height
      # Set true if title is to be hidden.
      attr_accessor :hide_title
      # Margin between the X axis and the bottom of the Axes artist.
      attr_accessor :x_axis_margin
      # Margin between the Y axis and the left of the Axes artist.
      attr_accessor :y_axis_margin
      # Position of the legend box.
      attr_accessor :legend_box_position

      # @param figure [Rubyplot::Figure] Figure object to which this Axes belongs.
      def initialize figure
        @figure = figure
        
        @x_title = ''
        @y_title = ''
        @x_axis_margin = 40.0
        @y_axis_margin = 40.0
        @x_range = [nil, nil]
        @y_range = [nil, nil]
        @x_tick_count = :default
        @y_tick_count = :default
        
        @origin = [nil, nil]
        @title = ""
        @title_shift = 0
        @title_margin = TITLE_MARGIN
        @text_font = :default
        @grid = true
        @bounding_box = true
        @x_ticks = {}
        @plots = []

        @raw_rows = width * (height/width)

        @theme = Rubyplot::Themes::CLASSIC_WHITE
        @geometry = Rubyplot::MagickWrapper::Plot::Scatter::Geometry.new
        vera_font_path = File.expand_path('Vera.ttf', ENV['MAGICK_FONT_PATH'])
        @font = File.exist?(vera_font_path) ? vera_font_path : nil
        @font_color = "#000000"
        @marker_font_size = 15.0
        @legend_font_size = 20.0
        @legend_margin = LEGEND_MARGIN
        @title_font_size = 25.0
        @backend = @figure.backend
        @plot_colors = []
        @legends = []
        @lines = []
        @texts = []
        @x_axis = nil
        @y_axis = nil

        @legend_box_position = :top
      end

      # X co-ordinate of the legend box depending on value of @legend_box_position.
      def legend_box_ix
        case @legend_box_position
        when :top
          abs_y + width / 2
        end
      end

      # Y co-ordinate of the legend box depending on value of @legend_box_position.
      def legend_box_iy
        case @legend_box_position
        when :top
          abs_x + @x_axis_margin + @legend_margin
        end
      end
      
      # Write an image to a file by communicating with the backend.
      def draw
        configure_title
        calculate_xy_axes_origin
        configure_xy_axes
        configure_legends
        # configure_plotting_data
        actually_draw
        # @plots.each(&:draw)
      end

      def scatter! *args, &block
        plot = Rubyplot::Artist::Plot::Scatter.new self
        yield(plot) if block_given?
        @plots << plot
      end

      def bar! *args, &block
        plot = Rubyplot::Artist::Plot::Bar.new self
        yield(plot) if block_given?
        @plots << plot
      end

      def line! *args, &block
        plot = Rubyplot::Artist::Plot::Line.new self
        yield(plot) if block_given?
        @plots << plot
      end

      def area! *args, &block
        add_plot "Area", *args, &block
      end

      def bubble! *args, &block
        add_plot "Bubble", *args, &block
      end

      def dot! *args, &block
        add_plot "Dot", *args, &block      
      end

      def stacked_bar! *args, &block
        add_plot "StackedBar", *args, &block
      end

      def write file_name
        @plots[0].write file_name
      end
      
      # Absolute X co-ordinate of the Axes. Top left corner.
      def abs_x
        @figure.top_spacing * @figure.height + @figure.abs_x
      end
      
      # Absolute Y co-ordinate of the Axes. Top left corner.
      def abs_y
        @figure.top_spacing * @figure.height + @figure.abs_y
      end
      
      # Absolute width of the Axes in pixels.
      def width
        (1 - (@figure.left_spacing + @figure.right_spacing)) * @figure.width
      end

      # Absolute height of the Axes in pixels.
      # FIXME: expand for multiple axes on same figure. width too.
      def height
        (1 - (@figure.top_spacing + @figure.bottom_spacing)) * @figure.height
      end

      private

      def add_plot plot_type, *args, &block
        plot = with_backend plot_type, *args
        yield(plot) if block_given?
        @plots << plot
      end

      def with_backend plot_type, *args
        plot =
          case Rubyplot.backend
          when :magick
            Kernel.const_get("Rubyplot::MagickWrapper::Plot::#{plot_type}").new self, *args
          when :gr
            Kernel.const_get("Rubyplot::GRWrapper::Plot::#{plot_type}").new self, *args
          end

        plot
      end

      def prepare_legend
        @legends = @plots.map(&:create_legend)
        @legends.each { |l| l.draw }
      end
     
      # Calculates size of drawable area and generates normalized data.
      #
      # * line markers
      # * legend
      # * title
      # * labels
      # * X/Y offsets
      def setup_drawing
        calculate_spread
        normalize # FIXME: maybe doesnt need to go here.
        setup_graph_measurements
      end

      # Calculate spread of the data.
      def calculate_spread
        @y_spread = @y_range[1].to_f - @y_range[0].to_f
        unless @x_range[0].nil? && @x_range[1].nil?
          @x_spread = @x_range[1].to_f - @x_range[0].to_f
          @x_spread = @x_spread > 0 ? @x_spread : 1
        end
      end

      # Normalize data with values scaled between 0-100.
      def normalize
        @plots.each do |p|
          p.normalize @x_spread, @y_spread
        end
      end

      ##
      # Calculates size of drawable area, general font dimensions, etc.
      # This is the most crucial part of the code and is based on geometry.
      # It calcuates the measurments in pixels to figure out the positioning
      # gap pixels of Legends, Labels and Titles from the picture edge. 
      def setup_graph_measurements
        @marker_caps_height = @backend.caps_height @font, @marker_font_size
        @title_caps_height = @geometry.hide_title || @title.nil? ? 0 :
                               @backend.caps_height(@font, @title_font_size) *
                               @title.lines.to_a.size
        @legend_caps_height = @backend.caps_height @font, @legend_font_size

        # For now, the labels feature only focuses on the dot graph so it
        # makes sense to only have this as an attribute for this kind of
        # graph and not for others.
        if @geometry.has_left_labels
          text = @y_ticks.values.inject('') { |value, memo|
            value.to_s.length > memo.to_s.length ? value : memo
          }
          longest_left_label_width = @backend.string_width(
            @marker_font_size, text) * 1.25
        else
          longest_left_label_width = @backend.string_width(
            @font, @marker_font_size,
            label_string(@y_range[1].to_f, @geometry.increment))
        end

        # Shift graph if left line numbers are hidden
        line_number_width = @geometry.hide_line_numbers && !@geometry.has_left_labels ?
                              0.0 : (longest_left_label_width + LABEL_MARGIN * 2)
        # Pixel offset from the left edge of the plot
        @graph_left = @geometry.left_margin +
                      line_number_width +
                      (@geometry.y_axis_label.nil? ? 0.0 : @marker_caps_height + LABEL_MARGIN * 2)
        # Make space for half the width of the rightmost column label.
        # last_label = @x_ticks.keys.max.to_i
        # extra_room_for_long_label = last_label >= (@geometry.column_count - 1) &&
        #                             @geometry.center_labels_over_point ?
        #                               @backend.string_width(
        #                               @font,
        #                               @marker_font_size,
        #                               @x_ticks[last_label]) / 2.0 : 0
        extra_room_for_long_label = 0
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
                           @title_margin :
                           @title_caps_height + @title_margin) +
                        (@legend_caps_height + @legend_margin))

        x_axis_label_height = @geometry.x_axis_label .nil? ? 0.0 :
                                @marker_caps_height + LABEL_MARGIN

        # The actual height of the graph inside the whole image in pixels.
        @graph_bottom = @raw_rows - @graph_bottom_margin -
                        x_axis_label_height - @geometry.label_stagger_height
        @graph_height = @graph_bottom - @graph_top
      end

      # Figure out the co-ordinates of the title text w.r.t Axes.
      def configure_title
        @title = Rubyplot::Artist::Text.new(
          @title,
          self,
          abs_x: abs_x + width / 2,
          abs_y: abs_y + @title_margin,
          font: @font,
          color: @font_color,
          pointsize: @title_font_size,
          internal_label: "axes title."
        )
      end

      def calculate_xy_axes_origin
        @origin[0] = abs_x + @x_axis_margin
        @origin[1] = abs_y + height - @y_axis_margin
      end

      # Figure out co-ordinatees of the XAxis and YAxis
      def configure_xy_axes
        @x_axis = Rubyplot::Artist::XAxis.new(
          self, @x_title, @x_range[0], @x_range[1])
        @y_axis = Rubyplot::Artist::YAxis.new(
          self, @y_title, @y_range[0], @y_range[1])
      end

      # Figure out co-ordinates of the legends
      def configure_legends
        @legend_box = Rubyplot::Artist::LegendBox.new(
          self, abs_x: legend_box_ix, abs_y: legend_box_iy)
      end

      # Call the respective draw methods on each of the elements of this Axes.
      def actually_draw
        @x_axis.draw
        @y_axis.draw
        @title.draw
        @legend_box.draw
      end

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
          elsif ((@y_spread.to_f %
                  (@geometry.marker_count.to_f == 0 ?
                     1 : @geometry.marker_count.to_f) == 0) ||
                 !@geometry.y_axis_increment .nil?)
            value.to_i.to_s
          elsif @y_spread > 10.0
            format('%0i', value)
          elsif @y_spread >= 3.0
            format('%0.2f', value)
          else
            value.to_s
          end
        parts = label.split('.')
        parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{THOUSAND_SEPARATOR}")
        parts.join('.')
      end
    end # class Axes
  end # moudle Artist
end # module Rubyplot
