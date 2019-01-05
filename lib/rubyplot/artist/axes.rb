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
      
      # Rubyplot::Figure object to which this Axes belongs.
      attr_reader :figure
      # Array of plots contained in this Axes.
      attr_reader :plots
      attr_reader :font, :marker_font_size, :legend_font_size,
                  :title_font_size, :scale, :font_color, :marker_color, :axes,
                  :legend_margin, :backend, :marker_caps_height
      attr_reader :label_stagger_height
      # Rubyplot::Artist::XAxis object.
      attr_reader :x_axis
      # Rubyplot::Artist::YAxis object.
      attr_reader :y_axis
      # Array of X ticks.
      attr_reader :x_ticks
      # Array of Y ticks.
      attr_reader :y_ticks
      # Array denoting co-ordinates in pixels of the origin of X and Y axes.
      attr_reader :origin
      # Number of X ticks.
      attr_accessor :num_x_ticks
      # Number of Y ticks.
      attr_accessor :num_y_ticks
      # Position of the legend box.
      attr_accessor :legend_box_position
      # Set true if title is to be hidden.
      attr_accessor :hide_title
      # Margin between the X axis and the bottom of the Axes artist.
      attr_accessor :x_axis_margin
      # Margin between the Y axis and the left of the Axes artist.
      attr_accessor :y_axis_margin
      # Range of X axis.
      attr_accessor :x_range
      # Range of Y axis.
      attr_accessor :y_range, :grid, :bounding_box, :title_shift
      # Main title for this Axes.
      attr_accessor :title

      # @param figure [Rubyplot::Figure] Figure object to which this Axes belongs.
      def initialize(figure)
        @figure = figure

        @x_title = ''
        @y_title = ''
        @x_axis_margin = 40.0
        @y_axis_margin = 40.0
        @x_range = [nil, nil]
        @y_range = [nil, nil]
        @title = ''
        @title_shift = 0
        @title_margin = TITLE_MARGIN
        @text_font = :default
        @grid = true
        @bounding_box = true
        @plots = []
        @raw_rows = width * (height/width)
        @theme = Rubyplot::Themes::CLASSIC_WHITE
        vera_font_path = File.expand_path('Vera.ttf', ENV['MAGICK_FONT_PATH'])
        @font = File.exist?(vera_font_path) ? vera_font_path : nil
        @font_color = '#000000'
        @marker_font_size = 15.0
        @legend_font_size = 20.0
        @legend_margin = LEGEND_MARGIN
        @title_font_size = 25.0
        @backend = @figure.backend
        @plot_colors = []
        @legends = []
        @lines = []
        @texts = []
        @origin = [nil, nil]
        calculate_xy_axes_origin
        @x_axis = Rubyplot::Artist::XAxis.new(self)
        @y_axis = Rubyplot::Artist::YAxis.new(self)
        @x_ticks = nil
        @y_ticks = nil
        @num_x_ticks = 5
        @num_y_ticks = 4
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
        set_axes_ranges
        normalize_plotting_data
        assign_default_label_colors
        consolidate_plots
        configure_title
        configure_legends
        assign_x_ticks
        assign_y_ticks
        actually_draw
      end

      def scatter!(*_args)
        plot = Rubyplot::Artist::Plot::Scatter.new self
        yield(plot) if block_given?
        @plots << plot
      end

      def bar!(*_args)
        plot = Rubyplot::Artist::Plot::Bar.new self
        yield(plot) if block_given?
        @plots << plot
      end

      def line!(*_args)
        plot = Rubyplot::Artist::Plot::Line.new self
        yield(plot) if block_given?
        @plots << plot
      end

      def area!(*_args)
        plot = Rubyplot::Artist::Plot::Area.new self
        yield(plot) if block_given?
        @plots << plot
      end

      def bubble!(*_args)
        plot = Rubyplot::Artist::Plot::Bubble.new self
        yield(plot) if block_given?
        @plots << plot
      end

      def dot!(*args, &block)
        add_plot 'Dot', *args, &block
      end

      def stacked_bar!(*_args)
        plot = Rubyplot::Artist::Plot::StackedBar.new self
        yield(plot) if block_given?
        @plots << plot
      end

      def write(file_name)
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

      def x_ticks= x_ticks
        @x_ticks = x_ticks
      end

      def y_ticks= y_ticks
        @y_ticks = y_ticks
      end

      def x_title= x_title
        @x_axis.title = x_title
      end

      def y_title= y_title
        @y_axis.title = y_title
      end

      private

      def assign_default_label_colors
        @plots.each_with_index do |p, i|
          if p.color == :default
            p.color = @figure.theme_options[:label_colors][
              i % @figure.theme_options[:label_colors].size]
          end
        end
      end

      def assign_x_ticks
        @inter_x_ticks_distance = @x_axis.length / (@num_x_ticks.to_f-1)
        unless @x_ticks
          value_distance = (@x_range[1] - @x_range[0]) / (@num_x_ticks.to_f - 1)
          @x_ticks = @num_x_ticks.times.map do |i|
            @x_range[0] + i * value_distance
          end
        end

        unless @x_ticks.all? { |t| t.is_a?(Rubyplot::Artist::XTick) }
          @x_ticks.map!.with_index do |tick_label, i|
            Rubyplot::Artist::XTick.new(
              self,
              abs_x: i * @inter_x_ticks_distance + @x_axis.abs_x1,
              abs_y: @origin[1],
              label: Rubyplot::Utils.format_label(tick_label),
              length: 6,
              label_distance: 10
            )
          end
        end
      end

      def assign_y_ticks
        unless @y_ticks
          val_distance = (@y_range[1] - @y_range[0]).abs / @num_y_ticks.to_f
          @y_ticks = (@y_range[0]..@y_range[1]).step(val_distance).map { |i| i }
        end
        unless @y_ticks.all? { |t| t.is_a?(Rubyplot::Artist::YTick) }
          inter_ticks_distance = @y_axis.length / (@num_y_ticks - 1)
          @y_ticks.map!.with_index do |tick_label, i|
            Rubyplot::Artist::YTick.new(
              self,
              abs_x: @origin[0],
              abs_y: @y_axis.abs_y1 - (i * inter_ticks_distance),
              label: Rubyplot::Utils.format_label(tick_label),
              length: 6,
              label_distance: 50
            )
          end
        end
      end

      def add_plot plot_type, *args, &block
        plot = with_backend plot_type, *args
        yield(plot) if block_given?
        @plots << plot
      end

      def with_backend(plot_type, *args)
        plot =
          case Rubyplot.backend
          when :magick
            Kernel.const_get("Rubyplot::MagickWrapper::Plot::#{plot_type}").new self, *args
          when :gr
            Kernel.const_get("Rubyplot::GRWrapper::Plot::#{plot_type}").new self, *args
          end
        plot
      end

      # Figure out the co-ordinates of the title text w.r.t Axes.
      def configure_title
        @texts << Rubyplot::Artist::Text.new(
          @title, self, abs_x: abs_x + width / 2, abs_y: abs_y + @title_margin,
          font: @font, color: @font_color,
          pointsize: @title_font_size, internal_label: 'axes title.'
        )
      end

      def calculate_xy_axes_origin
        @origin[0] = abs_x + @x_axis_margin
        @origin[1] = abs_y + height - @y_axis_margin
      end

      # Figure out co-ordinates of the legends
      def configure_legends
        @legend_box = Rubyplot::Artist::LegendBox.new(
          self, abs_x: legend_box_ix, abs_y: legend_box_iy
        )
      end

      # Make adjustments to the data that will be plotted. Maps the data
      # contained in the plot to actual pixel values.
      def normalize_plotting_data
        @plots.each do |plot|
          plot.normalize
        end
      end

      # Call the respective draw methods on each of the elements of this Axes.
      def actually_draw
        @x_axis.draw
        @x_ticks.each(&:draw)
        @y_ticks.each(&:draw)
        @y_axis.draw
        @texts.each(&:draw)
        @legend_box.draw
        @plots.each(&:draw)
      end

      def consolidate_plots
        bars = @plots.grep(Rubyplot::Artist::Plot::Bar)
        unless bars.empty?
          @plots.delete_if { |p| p.is_a?(Rubyplot::Artist::Plot::Bar) }
          @plots << Rubyplot::Artist::Plot::MultiBars.new(self, bar_plots: bars)
        end

        stacked_bars = @plots.grep(Rubyplot::Artist::Plot::StackedBar)
        unless stacked_bars.empty?
          @plots.delete_if { |p| p.is_a?(Rubyplot::Artist::Plot::StackedBar) }
          @plots << Rubyplot::Artist::Plot::MultiStackedBar.new(self, stacked_bars: stacked_bars)
        end
      end

      # FIXME: replace x_range and y_range with XAxis::max/min_value and YAxis::max/min_value.
      def set_axes_ranges
        set_xrange
        set_yrange
      end

      def set_xrange
        if @x_range[0].nil? && @x_range[1].nil?
          @x_range[0] = @plots.map(&:x_min).min
          @x_range[1] = @plots.map(&:x_max).max
        end
        @x_axis.min_val = @x_range[0]
        @x_axis.max_val = @x_range[1]
      end

      def set_yrange
        if @y_range[0].nil? && @y_range[1].nil?
          @y_range[0] = @plots.map { |p| p.y_min }.min
          @y_range[1] = @plots.map { |p| p.y_max }.max
        end
        @y_axis.min_val = @y_range[0]
        @y_axis.max_val = @y_range[1]
      end
    end
    # class Axes
  end
  # moudle Artist
end
# module Rubyplot
