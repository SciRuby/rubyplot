module Rubyplot
  module Artist
    class Text < Artist::Base
      attr_reader :color, :font, :font_size,
        :stroke, :weight, :gravity, :text, :backend
      # X and Y co-oridinates specified in Rubyplot Artist Co-ordinates.
      attr_reader :abs_x, :abs_y
      # Owner Artist of the text.
      attr_reader :owner

      # Array containing valid horizontal alignment types.
      HAlignment = [
        :normal,
        :left,
        :center,
        :right
      ].freeze

      # Array containing valid vertical alignment types.
      VAlignment = [
        :normal,
        :top,
        :cap,
        :half,
        :base,
        :bottom
      ].freeze

      # Initialize a Text object.
      #
      # @param text [String] Text to be written to the output.
      # @param owner [Rubyplot::Artist::*] Owner object. Usually either Axes or Figure.
      # @param abs_x [Numeric] X co-ordinate of the text to plot between MIN_X and MAX_X.
      # @param abs_y [Numeric] Y co-ordinate of the text to plot between MIN_Y and MAX_Y.
      # @param font [Symbol] :times_roman Font to be used.
      # rubocop:disable Metrics/ParameterLists
      def initialize(text, owner, abs_x:, abs_y:,font: :times_roman,
        color: :black, size:, internal_label: '', rotation: nil,
        weight: nil, halign: :normal, valign: :normal, direction: :left_right)
        @abs_x = abs_x
        @abs_y = abs_y
        @text = text
        @owner = owner
        @font = font
        @color = color
        @size = size
        @internal_label = internal_label
        @rotation = rotation
        if HAlignment.include? halign
          @halign = halign
        else
          raise "Invalid horizontal alignment #{halign}."
        end

        if VAlignment.include? valign
          @valign = valign
        else
          raise "Invalid vertical alignment #{valign}."
        end
      end
      # rubocop:enable Metrics/ParameterLists

      # Height in pixels of this text
      def height
        Rubyplot.backend.text_height(@text, @font, @font_size)
      end

      # Width in pixels of this text
      def width
        Rubyplot.backend.text_width(@text, @font, @font_size)
      end

      def draw
        Rubyplot.backend.draw_text(
          @text,
          color: @color,
          font: @font,
          size: @size,
          abs_x: @abs_x,
          abs_y: @abs_y,
          rotation: @rotation,
          halign: @halign,
          valign: @valign
        )
      end
    end # class Text
  end # class Artist
end # module Rubyplot
