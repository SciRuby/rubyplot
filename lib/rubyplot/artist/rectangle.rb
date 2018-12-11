module Rubyplot
  module Artist
    class Rectangle < Base
      attr_reader :width, :height, :color

      def initialize(owner,abs_x:,abs_y:,width:,height:,color:)
        super(owner.backend, abs_x, abs_y)
        @height = height
        @width = width
        @color = color
      end

      def draw
        @backend.draw_rectangle(
          x1: @abs_x,
          y1: @abs_y,
          x2: @abs_x + @width,
          y2: @abs_y + @height,
          color: @color
        )
      end
    end # class Rectangle
  end # class Artist
end # moduel Rubyplot
