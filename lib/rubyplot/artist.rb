require_relative 'artist/legend'
require_relative 'artist/line'
require_relative 'artist/tick'
require_relative 'artist/axis'
require_relative 'artist/text'

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

   # left margin of the actual plot
   attr_reader :graph_left

   # top margin of the actual plot to leave space for the title
   attr_reader :graph_top

   # total width of the actual graph
   attr_reader :graph_width

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
      @marker_font_size = 15.0
      @legend_font_size = 20.0
      @legend_margin = LEGEND_MARGIN
      @title_font_size = 36.0
      @scale = @axes.width / @geometry.raw_columns
      @backend = create_backend
      @backend.scale(@scale)
      setup_default_theme
      @plot_colors = []
      @legends = []
      @lines = []
      @texts = []
      @x_axis = nil
      @y_axis = nil
    end
    
    def data y_values
      @data[:y_values] = y_values
      # Set column count if this is larger than previous column counts
      @geometry.column_count = y_values.length > @geometry.column_count ?
                                 y_values.length : @geometry.column_count

      # FIXME: move this to XAxis and YAxis later.
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
      prepare_xy_axes
      prepare_line_markers
      prepare_title
      @backend.write file_name
    end

    def label= label
      @data[:label] = label
    end

    def color= color
      @data[:color] = color
    end

    private

    def prepare_xy_axes
      @x_axis = Rubyplot::Artist::XAxis.new(
        @axes, self, @geometry.x_min_value, @geometry.x_max_value)
      @y_axis = Rubyplot::Artist::YAxis.new(
        @axes, self, @geometry.y_min_value, @geometry.y_max_value)
      @x_axis.draw
      @y_axis.draw
    end

    # Draw horizontal background lines and labels.
    def prepare_line_markers
      
    end

    def prepare_title
      
    end

    def prepare_legend
      @legends << Rubyplot::Artist::Legend.new(@axes, self, [@data[:label]], [@plot_colors[0]])
      @legends.each { |l| l.draw }
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
                    (@geometry.y_axis_label.nil? ? 0.0 : @marker_caps_height + LABEL_MARGIN * 2)
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
end # module Rubyplot
