module Rubyplot
  module Artist
    class Legend < Artist::Base
      TOP_MARGIN = 1
      BOTTOM_MARGIN = 0.5
      # Space between the color box and the legend text.
      BOX_AND_TEXT_SPACE = 0.5
      attr_reader :legend_box_size, :font, :font_size, :font_color

      # rubocop:disable Metrics/ParameterLists
      def initialize(legend_box, axes, text:, color:,abs_x:,abs_y:)
        super(abs_x, abs_y)
        @legend_box = legend_box
        @axes = axes
        @text = text
        @color = color
        @legend_box_size = @legend_box.per_legend_height -
                           (TOP_MARGIN + BOTTOM_MARGIN) # size of the color box of the legend.
        @font_size = 20.0
        @font = @axes.font
        @font_color = @axes.font_color
        configure_legend_color_box
        configure_legend_text
      end
      # rubocop:enable Metrics/ParameterLists

      def draw
        @legend_color_box.draw
        @text.draw
      end

      private

      def configure_legend_color_box
        @legend_color_box = Rubyplot::Artist::Rectangle.new(
          self,
          x1: @abs_x,
          y1: @abs_y + BOTTOM_MARGIN,
          x2: @abs_x + @legend_box_size,
          y2: @abs_y + @legend_box_size + BOTTOM_MARGIN,
          border_color: :black,
          border_width: 2,
          fill_color: @color,
          abs: true
        )
      end

      def configure_legend_text
        @text = Rubyplot::Artist::Text.new(
          @text,
          self,
          abs_x: @abs_x + @legend_box_size + BOX_AND_TEXT_SPACE,
          abs_y: @abs_y + BOTTOM_MARGIN * 2,
          font: @font,
          color: @font_color,
          size: @font_size
        )
      end
    end # class Legend
  end # class Artist
end # module Rubyplot
