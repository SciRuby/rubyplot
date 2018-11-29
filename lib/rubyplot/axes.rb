
module Rubyplot
  module Plot
    class Scatter < Rubyplot::Artist
      attr_reader :geometry
      
      def intialize(*)
        super
      end
      
      def data x_values, y_values
        super y_values
        @data[:x_values] = x_values
        if @geometry.x_max_value.nil? && @geometry.x_min_value.nil?
          @geometry.x_max_value = @geometry.x_min_value = x_values.first
        end
        @geometry.x_max_value = x_values.max > @geometry.x_max_value ?
                                      x_values.max : @geometry.x_max_value
        @geometry.x_min_value = x_values.min < @geometry.x_min_value ?
                                      x_values.min : @geometry.x_min_value
      end
    end
  end
end

module Rubyplot
  class Axes
    TITLE_MARGIN = 20.0
    DEFAULT_TARGET_WIDTH = 800

    attr_accessor :x_title

    attr_accessor :y_title, :x_range, :y_range,
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

    attr_reader :plots

    # Position of this Axes object in the subplots.
    attr_reader :position

    # Width in pixels of the graph
    attr_reader :width

    # Height in pixels of the graph
    attr_reader :height

    # data variables for something
    attr_reader :raw_rows

    def initialize figure, position
      @figure = figure
      @position = position
      
      @x_title = ''
      @y_title = ''
      @x_range = [0, 0]
      @y_range = [0, 0]
      @x_tick_count = :default
      @y_tick_count = :default
      
      @origin = %i[default default]
      @title = nil
      @title_shift = 0
      @title_margin = TITLE_MARGIN
      @text_font = :default
      @grid = true
      @bounding_box = true
      @x_axis_padding = :default
      @y_axis_padding = :default
      @x_ticks = {}
      @plots = []

      @width = DEFAULT_TARGET_WIDTH
      @height = @width * 0.75

      @raw_rows = 800.0 * (@height/@width)
    end

    # Set the dimensions in pixels of the graph. Format: "widthxheight". so "800x600".
    def dim= dim_string
      @width, @height = dim_string.split('x').map(&:to_f)
    end

    def scatter! *args, &block
      plot = Rubyplot::Plot::Scatter.new self, *args
      yield(plot) if block_given?
      @plots << plot
    end

    def bar! *args, &block
      add_plot "Bar", *args, &block
    end

    def line! *args, &block
      add_plot "Line", *args, &block
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
  end # class Axes
end # module Rubyplot
