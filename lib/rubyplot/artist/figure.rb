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
      attr_reader :font_color

      # Initialize a Rubyplot::Artist::Figure object.
      # @param height [Integer] nil Height in pixels of the complete Figure.
      # @param width [Integer] nil Width in pixels of the complete Figure.
      def initialize(height: nil, width: nil)
        @title = ''
        @nrows = 1
        @ncols = 1
        @backend = Rubyplot::Backend::MagickWrapper.new
        @width = width || DEFAULT_TARGET_WIDTH
        @height = height || @width * 0.75
        @abs_x = 0
        @abs_y = 0
        @top_spacing = 0.05
        @bottom_spacing = 0.05
        @left_spacing = 0.05
        @right_spacing = 0.05
        setup_default_theme
        add_subplots @nrows, @ncols
      end

      def add_subplots(nrows, ncols)
        @subplots = Array.new(nrows) { Array.new(ncols) { nil } }
      end

      def add_subplot(nrow, ncol)
        @subplots[nrow][ncol] = Rubyplot::Artist::Axes.new(self)
      end

      def write(file_name)
        @subplots.each { |i| i.each(&:draw) }
        @backend.write(file_name)
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
        @backend.set_base_image_gradient(
          Rubyplot::Color::COLOR_INDEX[@theme_options[:background_colors][0]],
          Rubyplot::Color::COLOR_INDEX[@theme_options[:background_colors][1]],
          @width,
          @height,
          @theme_options[:background_direction]
        )
      end
    end
    # class Figure
  end
  # module Artist
end
# module Rubyplot
