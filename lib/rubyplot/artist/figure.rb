module Rubyplot
  module Artist
    class Figure < Artist::Base
      DEFAULT_TARGET_WIDTH = 800

      # Title on the figure.
      attr_reader :title
      # Number of Axes objects in the rows.
      attr_reader :nrows
      # Number of Axes objects in the cols.
      attr_reader :ncols
      # Total width of the Figure in pixels.
      attr_reader :width
      # Total height of the Figure in pixels.
      attr_reader :height
      # Ratio of the total height that is the spacing between the top of the
      #   Figure and the top of the Axes.
      attr_reader :top_spacing
      # Ratio of the total width that is the spacing between the left of the
      #   Figure and the left of the Axes.
      attr_reader :left_spacing
      # Ratio of the total width that is the spacing between the right of the
      #   Figure and the right of the Axes.
      attr_reader :right_spacing
      # Ratio of the total width that is the spacing between the bottom of the
      #   Figure and the bottom of the Axes.
      attr_reader :bottom_spacing
      attr_reader :theme_options
      attr_reader :marker_color
      # Font color specified as a Symbol from Rubyplot::COLOR::COLOR_INDEX.
      attr_reader :font_color

      # Initialize a Rubyplot::Artist::Figure object.
      # @param height [Integer] nil Height in pixels of the complete Figure.
      # @param width [Integer] nil Width in pixels of the complete Figure.
      def initialize(height: nil, width: nil)
        super(0, 0)
        @title = ''
        @nrows = 1
        @ncols = 1
        @width = width || DEFAULT_TARGET_WIDTH
        @height = height || @width * 0.75
        @top_spacing = 5
        @bottom_spacing = 5
        @left_spacing = 5
        @right_spacing = 5
        @subplots = nil
        @n = 0
        setup_default_theme
        add_subplots @nrows, @ncols
      end

      # Create space for subplots to be added to the figure.
      #
      # @param nrows [Integer] Number of rows to add.
      # @param ncols [Integer] Number of cols to add.
      def add_subplots(nrows, ncols)
        @subplots = Array.new(nrows) { Array.new(ncols) { nil } }
      end

      # Actually create a subplot at position (nrow, ncol) on the figure.
      # You must call `add_subplots` and create space in the figure before
      # calling this method. Returns the created Rubyplot::Axes object.
      # 
      # @param nrow [Integer] X co-ordinate of the subplot.
      # @param ncol [Integer] Y co-ordinate of the subplot.
      def add_subplot(nrow, ncol)
        # FIXME: make this work for mutliple subplots.
        @subplots[nrow][ncol] = Rubyplot::Artist::Axes.new(
          self,
          abs_x: @left_spacing + @abs_x,
          abs_y: @bottom_spacing + @abs_y,
          width: Rubyplot::MAX_X - (@left_spacing + @right_spacing),
          height: Rubyplot::MAX_Y - (@top_spacing + @bottom_spacing)
        )
        @subplots[nrow][ncol]
      end

      def set_background_gradient
        Rubyplot.backend.set_base_image_gradient(
          Rubyplot::Color::COLOR_INDEX[@theme_options[:background_colors][0]],
          Rubyplot::Color::COLOR_INDEX[@theme_options[:background_colors][1]],
          @width,
          @height,
          @theme_options[:background_direction]
        )
      end

      # Draw on a canvas and output to a file.
      #
      # @param output [TrueClass, FalseClass] true Whether to output to file or not.
      def write(file_name, output: true)
        Rubyplot.backend.canvas_height = @height
        Rubyplot.backend.canvas_width = @width
        Rubyplot.backend.figure = self
        Rubyplot.backend.init_output_device(file_name, device: :file) if output
        @subplots.each { |i| i.each(&:draw) }
        Rubyplot.backend.write file_name
        Rubyplot.backend.stop_output_device if output
      end

      private

      def setup_default_theme
        defaults = {
          marker_color: :white,
          font_color: :black,
          background_image: nil
        }
        @theme_options = defaults.merge Themes::CLASSIC_WHITE
        @marker_color = @theme_options[:marker_color]
        @font_color = @theme_options[:font_color] || @marker_color
      end
    end # class Figure
  end # module Artist
end # module Rubyplot
