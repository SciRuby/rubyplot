module Rubyplot
  module Artist
    class Text < Artist::Base
      # (X,Y) of upper left corner of the rectangle.
      attr_reader :color, :font, :font_size,
        :stroke, :weight, :gravity, :text, :backend

      # rubocop:disable Metrics/ParameterLists
      def initialize(text, owner, abs_x:, abs_y:,font: nil,
                     color: '#000000',font_size:,stroke: 'transparent',
                     internal_label: '', rotation: nil,
                     weight: nil, gravity: nil)
        super(abs_x, abs_y)
        @text = text
        @owner = owner
        @font = font
        @color = color
        @font_size = font_size
        @stroke = stroke
        @internal_label = internal_label
        @rotation = rotation
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
          font_color: @color,
          font: @font,
          font_size: @font_size,
          stroke: @stroke,
          x: @abs_x,
          y: @abs_y,
          rotation: @rotation
        )
      end
    end # class Text
  end # class Artist
end # module Rubyplot
