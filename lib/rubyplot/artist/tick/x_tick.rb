module Rubyplot
  class Artist
    class XTick < Tick::Base
      def initialize(*)
        super
        @label = Rubyplot::Artist::Text.new(
          @artist)
      end
      
      def draw
        @artist.backend.draw_line(
          x1: @x, y1: @y, x2: @x, y2: @y + @length)
      end
    end
  end # class Artist
end # module Rubyplot
