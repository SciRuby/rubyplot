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
      # Range of X axis.
      attr_accessor :x_range
      # Range of Y axis.
      attr_accessor :y_range,
                    :text_font, :grid,
                    :bounding_box, :origin,
                    :title_shift, :title_margin
      # Main title for this Axes.
      attr_accessor :title
      # Rubyplot::Figure object to which this Axes belongs.
      attr_reader :figure
      # Array of plots contained in this Axes.
      attr_reader :plots

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
      # Rubyplot::Artist::XAxis object.
      attr_reader :x_axis
      # Rubyplot::Artist::YAxis object.
      attr_reader :y_axis

      # @param figure [Rubyplot::Figure] Figure object to which this Axes belongs.
      def initialize figure
        @figure = figure
        
        @x_title = ''
        @y_title = ''
        @x_axis_margin = 40.0
        @y_axis_margin = 40.0
        @x_range = [nil, nil]
        @y_range = [nil, nil]

        @title = ""
        @title_shift = 0
        @title_margin = TITLE_MARGIN
        @text_font = :default
        @grid = true
        @bounding_box = true
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
        @origin = [nil, nil]
        calculate_xy_axes_origin
        @x_axis = Rubyplot::Artist::XAxis.new(self)
        @y_axis = Rubyplot::Artist::YAxis.new(self)

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
        assign_plot_defaults
        consolidate_plots
        gather_plot_data
        configure_title
        configure_legends
        configure_plotting_data
        actually_draw
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

      def x_ticks= x_ticks
        @x_axis.x_ticks = x_ticks
      end

      def x_title= x_title
        @x_axis.title = x_title
      end

      def y_title= y_title
        @y_axis.title = y_title
      end
      
      private

      def assign_plot_defaults
        assign_label_colors
      end

      def assign_label_colors
        @plots.each_with_index do |p, i|
          if p.color == :default
            p.color = @figure.theme_options[:label_colors][
              i % @figure.theme_options[:label_colors].size]
          end
        end
      end

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

      # Figure out co-ordinates of the legends
      def configure_legends
        @legend_box = Rubyplot::Artist::LegendBox.new(
          self, abs_x: legend_box_ix, abs_y: legend_box_iy)
      end

      # Make adjustments to the data that will be plotted. Maps the data
      # contained in the plot to actual pixel values.
      def configure_plotting_data
        @plots.each do |plot|
          plot.normalize
        end
      end

      # Call the respective draw methods on each of the elements of this Axes.
      def actually_draw
        @x_axis.draw
        @y_axis.draw
        @title.draw
        @legend_box.draw
        @plots.each(&:draw)
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

      def consolidate_plots
        bars = @plots.grep(Rubyplot::Artist::Plot::Bar)
        if !bars.empty?
          @plots.delete_if { |p| p.is_a?(Rubyplot::Artist::Plot::Bar) }
          @plots << Rubyplot::Artist::Plot::MultiBars.new(self, bar_plots: bars)
        end
      end

      # FIXME: replace x_range and y_range with XAxis::max/min_value and YAxis::max/min_value.
      def gather_plot_data
        set_xrange
        set_yrange
      end

      def set_xrange
        if @x_range[0].nil? && @x_range[1].nil?
          @x_range[0] = @plots.map { |p| p.x_min }.min
          @x_range[1] = @plots.map { |p| p.x_max }.max
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
    end # class Axes
  end # moudle Artist
end # module Rubyplot
