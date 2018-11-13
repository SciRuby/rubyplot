module Rubyplot
  module Artist
    class Text
      # (X,Y) of upper left corner of the rectangle.
      attr_reader :x, :y, :height, :width, :color, :font, :pointsize,
                  :stroke, :weight, :gravity, :text, :backend
      
      def initialize(text, owner, x:, y:, height:, width:,font: nil,
                     color: '#000000',pointsize:,stroke: 'transparent',
                     weight: nil,gravity: nil, internal_label: "", rotation: nil)
        @text = text
        @owner = owner
        @x = x
        @y = y
        @height = height
        @width = width
        @font = font
        @color = color
        @pointsize = pointsize
        @stroke = stroke
        @internal_label = internal_label
        @backend = @owner.backend
        @rotation = rotation
      end

      def draw
        @backend.draw_text(
          @text,
          font_color: @color,
          font: @font,
          pointsize: @pointsize,
          stroke: @stroke,
          width: @width,
          height: @height,
          x: @x,
          y: @y,
          rotation: @rotation
        )
      end
    end # class Text
  end # class Artist
end # module Rubyplot
