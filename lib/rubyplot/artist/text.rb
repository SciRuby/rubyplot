module Rubyplot
  module Artist
    class Text < Artist::Base
      # (X,Y) of upper left corner of the rectangle.
      attr_reader :color, :font, :pointsize,
                  :stroke, :weight, :gravity, :text, :backend
      
      def initialize(text, owner, abs_x:, abs_y:,font: nil,
                     color: '#000000',pointsize:,stroke: 'transparent',
                     weight: nil,gravity: nil, internal_label: "", rotation: nil)
        @text = text
        @owner = owner
        @abs_x = abs_x
        @abs_y = abs_y
        @font = font
        @color = color
        @pointsize = pointsize
        @stroke = stroke
        @internal_label = internal_label
        @backend = @owner.backend
        @rotation = rotation
      end

      # Height in pixels of this text
      def height
        @backend.text_height(@text, @font, @font_size)
      end

      # Width in pixels of this text
      def width
        @backend.text_width(@text, @font, @font_size)
      end

      def draw
        @backend.draw_text(
          @text,
          font_color: @color,
          font: @font,
          pointsize: @pointsize,
          stroke: @stroke,
          x: @abs_x,
          y: @abs_y,
          rotation: @rotation
        )
      end
    end # class Text
  end # class Artist
end # module Rubyplot
