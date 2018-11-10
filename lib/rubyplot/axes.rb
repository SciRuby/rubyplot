module Rubyplot
  class Axes
    TITLE_MARGIN = 20.0
    
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

    # Main title for this Axes.
    attr_accessor :title

    # Rubyplot::Figure object to which this Axes belongs.
    attr_reader :figure

    attr_reader :plots

    # Position of this Axes object in the subplots.
    attr_reader :position

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
    end

    def scatter! *args, &block
      plot = with_backend "Scatter", *args
      yield(plot) if block_given?
      @plots << plot
    end

    def bar! *args, &block
      plot = with_backend "Bar", *args
      yield(plot) if block_given?
      @plots << plot
    end

    def line! *args, &block
      plot = with_backend "Line", *args
      yield(plot) if block_given?
      @plots << plot
    end

    def write file_name
      @plots[0].write file_name
    end

    private

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
