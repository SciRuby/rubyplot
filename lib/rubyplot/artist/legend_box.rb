module Rubyplot
  module Artist
    class LegendBox < Base
      # Ratio of total height of legend box that is the top margin.
      TOP_SPACING_RATIO = 0.1
      # Ratio of the total height of the legend box that is the bottom margin.
      BOTTOM_SPACING_RATIO = 0.1
      # Ratio of the total width of the legend box that is the left margin.
      LEFT_SPACING_RATIO = 0.1
      # Ratio of the total width of the legend box that is the right margin.
      RIGHT_SPACING_RATIO = 0.1

      attr_accessor :border_color

      def initialize(axes, abs_x:, abs_y:)
        super(axes.backend, abs_x, abs_y)
        @axes = axes
        @border_color = :black
        @legends = []
        configure_dimensions
        configure_legends
        configure_legend_box
      end

      def draw
        unless @legends.empty?
          @bounding_box.draw
          @legends.each(&:draw)
        end
      end

      def top_margin
        TOP_SPACING_RATIO * @legends_height
      end

      def bottom_margin
        BOTTOM_SPACING_RATIO * @legends_height
      end

      def left_margin
        LEFT_SPACING_RATIO * @legends_width
      end

      def right_margin
        RIGHT_SPACING_RATIO * @legends_width
      end

      # Calculation of the height that each legend takes.
      def per_legend_height
        25.0
      end

      private

      def configure_legend_box
        @bounding_box = Rubyplot::Artist::Rectangle.new(
          self,
          abs_x: @abs_x,
          abs_y: @abs_y,
          width: @width,
          height: @height,
          border_color: @border_color
        )
      end

      def configure_dimensions
        @legends_height = @axes.plots.size * per_legend_height
        @legends_width = 0.2 * @axes.width
        @height = @legends_height + top_margin + bottom_margin
        @width = @legends_width + left_margin + right_margin
      end

      def configure_legends
        @axes.plots.each_with_index do |plot, count|
          next unless plot.label != ''

          @legends << Rubyplot::Artist::Legend.new(
            self,
            @axes,
            text: plot.label,
            color: plot.color,
            abs_x: @abs_x + left_margin,
            abs_y: @abs_y + count * per_legend_height + top_margin
          )
        end
      end
    end
    # class LegendBox
  end
  # module Artist
end
# module Rubyplot
