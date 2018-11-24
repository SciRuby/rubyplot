module Rubyplot  
  class Artist
    # Space around text elements. Mostly used for vertical spacing.
    # This way the vertical text doesn't overlap.
    LEGEND_MARGIN = TITLE_MARGIN = 20.0
    LABEL_MARGIN = 10.0
    DEFAULT_MARGIN = 20.0

    THOUSAND_SEPARATOR = ','.freeze
    
    attr_reader :geometry, :font, :marker_font_size, :legend_font_size,
                :title_font_size, :scale, :font_color, :marker_color, :axes,
                :legend_margin, :backend
              
   attr_reader :label_stagger_height
   # FIXME: possibly disposable attrs
   attr_reader :graph_height, :title_caps_height

    def initialize axes, *args
      @axes = axes
      @data = {
        label: :default,
        color: :default
      }
      @theme = Rubyplot::Themes::CLASSIC_WHITE
      @geometry = Rubyplot::MagickWrapper::Plot::Scatter::Geometry.new
      vera_font_path = File.expand_path('Vera.ttf', ENV['MAGICK_FONT_PATH'])
      @font = File.exist?(vera_font_path) ? vera_font_path : nil
      @marker_font_size = 21.0
      @legend_font_size = 20.0
      @legend_margin = LEGEND_MARGIN
      @title_font_size = 36.0
      @scale = @axes.width / @geometry.raw_columns
      @backend = create_backend
      @backend.scale(@scale)
      setup_default_theme
      @plot_colors = []
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
      construct_colors_array
      prepare_legend
      @backend.write file_name
    end

    def label= label
      @data[:label] = label
    end

    def color= color
      @data[:color] = color
    end

    private

    def prepare_legend
      @legend = Rubyplot::Artist::Legend.new @axes, self, [@data[:label]], [@data[:color]]
    end
    
    def setup_default_theme
      defaults = {
        marker_color: 'white',
        font_color: 'black',
        background_image: nil
      }
      @geometry.theme_options = defaults.merge Themes::CLASSIC_WHITE
      @marker_color = @geometry.theme_options[:marker_color]
      @font_color = @geometry.theme_options[:font_color] || @marker_color
      @backend.set_base_image_gradient(
        @geometry.theme_options[:background_colors][0],
        @geometry.theme_options[:background_colors][1],
        @geometry.theme_options[:background_direction])
    end
    
    def create_backend
      case Rubyplot.backend
      when :magick
        Rubyplot::Backend::MagickWrapper.new self
      end
    end

    def construct_colors_array
      return unless @plot_colors.empty?
      if (@data[:color] == :default)
        @plot_colors.push(@geometry.theme_options[:label_colors][0])
      else
        @plot_colors.push(Rubyplot::Color::COLOR_INDEX[@data[:color]])
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
      @marker_caps_height = @backend.caps_height @marker_font_size
      @title_caps_height = @geometry.hide_title || @axes.title.nil? ? 0 :
                             @backend.caps_height(@title_font_size) * @axes.title.lines.to_a.size
      @legend_caps_height = @backend.caps_height(@legend_font_size)

      # For now, the labels feature only focuses on the dot graph so it
      # makes sense to only have this as an attribute for this kind of
      # graph and not for others.
      if @geometry.has_left_labels
        text = @axes.y_ticks.values.inject('') { |value, memo|
          value.to_s.length > memo.to_s.length ? value : memo
        }
        longest_left_label_width = @backend.string_width(
          @marker_font_size, text) * 1.25
      else
        longest_left_label_width = @backend.string_width(
          @marker_font_size,
          label_string(@geometry.y_max_value.to_f, @geometry.increment))
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
                                    @backend.string_width(@marker_font_size,
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
                      (@legend_caps_height + @legend_margin))

      x_axis_label_height = @geometry.x_axis_label .nil? ? 0.0 :
                              @marker_caps_height + LABEL_MARGIN

      # The actual height of the graph inside the whole image in pixels.
      @graph_bottom = @axes.raw_rows - @graph_bottom_margin -
                      x_axis_label_height - @geometry.label_stagger_height
      @graph_height = @graph_bottom - @graph_top
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
  end # class Artist

  class Artist
    class Legend
      attr_reader :legend_box_size, :font, :font_size, :font_color
      
      # legends - [String] Array of strings that has legend names.
      # colors - [String] Array of corresponding colors
      def initialize axes, artist, legends, colors
        @axes = axes
        @artist = artist
        @legends = legends
        @colors = colors
        @legend_box_size = 20.0 # size of the color box of the legend.
        @font_size = 20.0
        @font = @artist.font
        @font_color = @artist.font_color
        calculate_legend_size
        calculate_offsets
      end

      def draw
        draw_legend_text
        draw_legend_color_indicator
      end

      private

      def draw_legend_text
        @legends.each do |legend|
          @artist.backend.draw_text(legend,
                                    font_color: @font_color,
                                    font: @font,
                                   )
        end
      end

      def draw_legend_color_indicator
        
      end
      
      # FIXME: should work for multiple legends.
      def calculate_offsets
        @current_x_offset = (@artist.geometry.raw_columns -
                             @label_widths.first.inject(:+))/2
        @current_y_offset = if @artist.geometry.legend_at_bottom
                              @artist.graph_height + @axes.title_margin
                            else
                              if @artist.geometry.hide_title
                                @artist.geometry.top_margin + @axes.title_margin
                              else
                                @artist.geometry.top_margin +
                                  @axes.title_margin + @artist.title_caps_height
                              end                       
                            end
      end
      
      def calculate_legend_size
        # FIXME: below array consists of two arrays. If the legend overflows into another line,
        # it removes the element from the first array and put it in the second array.
        # so basically first array is for legends which have not overflowed and the second
        # is one which have. possibly rethink this data structure.
        @label_widths = [[]] # for calculating line wrap
        @legends.each do |legend|
          width, _ = @artist.backend.get_text_width_height legend
          label_width = width + @legend_box_size * 2.7 # FIXME: make value a global constant
          @label_widths.last.push label_width

          if @label_widths.last.inject(:+) > (@artist.geometry.raw_columns * 0.9)
            @label_widths.push [@label_widths.last.pop]
          end
        end
      end
    end # class Legend
  end # class Artist

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

  module Backend
    class MagickWrapper
      include ::Magick
      
      def initialize artist
        @artist = artist
        @draw = Magick::Draw.new
      end

      # Returns the height of the capital letter 'X' for the current font and
      # size.
      #
      # Not scaled since it deals with dimensions that the regular scaling will
      # handle.
      def caps_height font_size
        @draw.pointsize = font_size
        @draw.font = @artist.font if @font
        @draw.get_type_metrics(@base_image, 'X').height
      end

      # Returns the width of a string at this pointsize.
      #
      # Not scaled since it deals with dimensions that the regular
      # scaling will handle.
      # FIXME: duplicate with get_text_width_height
      def string_width font_size, text
        @draw.pointsize = font_size
        @draw.font = @artist.font if @font
        @draw.get_type_metrics(@base_image, text.to_s).height
      end

      # Scale backend canvas to required proportion.
      def scale scale
        @draw.scale(scale, scale)
      end

      def set_base_image_gradient top_color, bottom_color, direct=:top_bottom
        @base_image = render_gradient top_color, bottom_color, direct
      end

      # Get the width and height of the text in pixels.
      def get_text_width_height text
        metrics = @draw.get_type_metrics(@base_image, text)
        [metrics.width, metrics.height]
      end

      def write file_name
        @draw.draw(@base_image)
        @base_image.write(file_name)
      end

      private
      # Render a gradient and return an Image.
      def render_gradient top_color, bottom_color, direct
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
        Image.new(@artist.axes.width, @artist.axes.height, gradient_fill)
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

      @raw_rows = 800.0 * (@width/@height)
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
