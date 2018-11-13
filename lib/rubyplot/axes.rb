module Rubyplot  
  class Artist
    attr_reader :geometry
    
    def initialize axes, *args
      @axes = axes
      @data = {
        label: :default,
        color: :default
      }
      @theme = Rubyplot::Themes::CLASSIC_WHITE
      @backend = backend
      @geometry = Rubyplot::MagickWrapper::Plot::Scatter::Geometry.new
    end
    
    def data y_values
      @data[:y_values] = y_values
      # Set column count if this is larger than previous column counts
      @geometry.column_count = y_values.length > @geometry.column_count ?
                                 y_values.length : @geometry.column_count

      # Pre-normalize => Set the max and min values of the data.
      y_values.each do |val|
        # Initialize the maximum and minimum values so that the spread starts
        # at the lowest points in the data and then changes as iteration.
        if @geometry.y_max_value.nil? && @geometry.y_min_value.nil?
          @geometry.y_max_value = @geometry.y_min_value = val
        end
        @geometry.y_max_value = val > @geometry.y_max_value ?
                                    val : @geometry.y_max_value
        @geometry.y_min_value = val < @geometry.y_min_value ?
                                    val : @geometry.y_min_value
        @geometry.has_data = true
      end
    end

    # Write an image to a file by communicating with the backend.
    def write file_name
      setup_drawing
    end

    private
    
    def backend
      case Rubyplot.backend
      when :magick
        Rubyplot::Backend::MagickWrapper.new
      end
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
      normalize
      setup_graph_measurements
    end

    # Calculate spread of the data.
    def calculate_spread
      @y_spread = @geometry.y_max_value.to_f - @geometry.y_min_value.to_f
      unless @geometry.x_min_value.nil? && @geometry.x_max_value.nil?
        @x_spread = @geometry.x_max_value.to_f - @geometry.x_min_value.to_f
        @x_spread = @x_spread > 0 ? @x_spread : 1
      end
    end

    # Normalize data with values scaled between 0-100.
    def normalize
      @geometry.norm_data = []
      norm_data = [@data[:label]]
      norm_data << @data[:y_values].map do |val|
        (val.to_f - @geometry.y_min_value.to_f) / @y_spread
      end
      norm_data << @data[:color]
      if @data[:x_values]
        norm_data << @data[:x_values].map do |data_point|
          (data_point.to_f - @geometry.x_min_value.to_f) / @x_spread
        end
      end
      @geometry.norm_data << norm_data
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
  end

  module Plot
    class Scatter < Rubyplot::Artist
      attr_reader :geometry
      
      def intialize(*)
        super
      end
      
      def data x_values, y_values
        puts "self #{self}"
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

      def calculate_spread

      end
    end
  end

  module Backend
    class MagickWrapper
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
