module Rubyplot
  module Artist
    class Axes < Base
      TITLE_MARGIN = 10.0
      LEGEND_MARGIN = 15.0
      LABEL_MARGIN = 10.0
      DEFAULT_MARGIN = 10.0
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
      # Array denoting co-ordinates of the origin of X and Y axes. [x, y].
      attr_accessor :origin
      # Position of the legend box.
      attr_accessor :legend_box_position
      # Set true if title is to be hidden.
      attr_accessor :hide_title
      # Top margin.
      attr_accessor :top_margin
      # Left margin.
      attr_accessor :left_margin
      # Bottom margin.
      attr_accessor :bottom_margin
      # Right margin.
      attr_accessor :right_margin
      # Range of X axis.
      attr_accessor :x_range
      # Range of Y axis.
      attr_accessor :y_range, :grid, :bounding_box, :title_shift
      # Main title for this Axes.
      attr_accessor :title
      # X co-ordinate of lower left corner of this Axes.
      attr_accessor :abs_x
      # Y co-ordinate of lower left corner of this Axes.
      attr_accessor :abs_y
      # Width of this Axes object. Between Rubyplot::MIN_X and MAX_X.
      attr_accessor :width
      # Height of this Axes object. Between Rubyplot::MIN_Y and MAX_Y.
      attr_accessor :height
      
      # @param figure [Rubyplot::Figure] Figure object to which this Axes belongs.
      # @param abs_x [Float] Absolute X co-ordinate of the lower left corner of the Axes.
      # @param abs_y [Flot] Absolute Y co-ordinate of the lower left corner of the Axes.
      # @param width [Float] Width between MIN_X and MAX_Y of this Axes object.
      # @param height [Float] Height between MIN_Y and MAX_Y of this Axes object.
      def initialize(figure, abs_x:, abs_y:, width:, height:)
        @figure = figure
        @abs_x = abs_x
        @abs_y = abs_y
        @width = width
        @height = height

        @x_title = ''
        @y_title = ''
        @top_margin = 5.0
        @left_margin = 5.0
        @bottom_margin = 5.0
        @right_margin = 5.0
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
        @font_color = :black
        @marker_font_size = 15.0
        @legend_font_size = 20.0
        @legend_margin = LEGEND_MARGIN
        @title_font_size = 25.0
        @plot_colors = []
        @legends = []
        @lines = []
        @texts = []
        @origin = nil
        @x_axis = Rubyplot::Artist::XAxis.new(self)
        @y_axis = Rubyplot::Artist::YAxis.new(self)
        @legend_box_position = :top
      end

      # X co-ordinate of the legend box depending on value of @legend_box_position.
      def legend_box_ix
        case @legend_box_position
        when :top
          abs_x + width / 2
        end
      end

      # Y co-ordinate of the legend box depending on value of @legend_box_position.
      def legend_box_iy
        case @legend_box_position
        when :top
          abs_y + height - @top_margin - @legend_margin
        end
      end

      # Write an image to a file by communicating with the backend.
      def draw
        Rubyplot.backend.active_axes = self
        set_axes_ranges
        set_default_origin unless @origin
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

      def stacked_bar!(*_args)
        plot = Rubyplot::Artist::Plot::StackedBar.new self
        yield(plot) if block_given?
        @plots << plot
      end

      def write(file_name)
        @plots[0].write file_name
      end

      def x_ticks= x_ticks
        @x_axis.major_ticks = x_ticks
      end

      def y_ticks= y_ticks
        @y_axis.major_ticks = y_ticks
      end

      def x_title= x_title
        @x_axis.title = x_title
      end

      def y_title= y_title
        @y_axis.title = y_title
      end

      private

      def set_default_origin
        @origin = [@x_axis.min_val, @y_axis.min_val]
      end

      def assign_default_label_colors
        @plots.each_with_index do |p, i|
          if p.color == :default
            p.color = @figure.theme_options[:label_colors][
              i % @figure.theme_options[:label_colors].size]
          end
        end
      end

      def assign_x_ticks
        value_distance = @x_axis.spread / (@x_axis.major_ticks_count.to_f - 1)
        unless @x_axis.major_ticks # create labels if not present
          @x_axis.major_ticks = @x_axis.major_ticks_count.times.map do |i|
            @x_axis.min_val + i * value_distance
          end
        end

        unless @x_axis.major_ticks.all? { |t| t.is_a?(Rubyplot::Artist::XTick) }
          @x_axis.major_ticks.map!.with_index do |tick_label, i|
            Rubyplot::Artist::XTick.new(
              self,
              coord: i * value_distance + @x_axis.min_val,
              label: Rubyplot::Utils.format_label(tick_label)
            )
          end
        end
      end

      def assign_y_ticks
        value_distance = @y_axis.spread / (@y_axis.major_ticks_count.to_f-1)
        unless @y_axis.major_ticks
          @y_axis.major_ticks = (@y_range[0]..@y_range[1]).step(value_distance).map { |i| i }
        end
        
        unless @y_axis.major_ticks.all? { |t| t.is_a?(Rubyplot::Artist::YTick) }
          @y_axis.major_ticks.map!.with_index do |tick_label, i|
            Rubyplot::Artist::YTick.new(
              self,
              coord: @y_axis.min_val + i * value_distance,
              label: Rubyplot::Utils.format_label(tick_label)
            )
          end
        end
      end

      # Figure out the co-ordinates of the title text w.r.t Axes.
      def configure_title
        @texts << Rubyplot::Artist::Text.new(
          @title, self,
          abs_x: abs_x + width / 2, abs_y: abs_y + height - @title_margin,
          font: @font, color: @font_color,
          font_size: @title_font_size, internal_label: 'axes title.')
      end

      def calculate_xy_axes_origin
        @origin[0] = abs_x + @left_margin
        @origin[1] = abs_y + @bottom_margin
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
          @y_range[0] = @plots.map(&:y_min).min
          @y_range[1] = @plots.map(&:y_max).max
        end
        @y_axis.min_val = @y_range[0]
        @y_axis.max_val = @y_range[1]
      end
    end # class Axes
  end # module Artist
end # module Rubyplot
