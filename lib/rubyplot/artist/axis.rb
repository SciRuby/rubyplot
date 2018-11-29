module Rubyplot
  class Artist
    class Axis
      def initialize axes,artist, x1:,y1:,x2:,y2:,label: nil
        @axes = axes
        @artist = artist
        @x1 = x1
        @x2 = x2
        @y1 = y1
        @y2 = y2
        @label = label
      end

      def draw
        @artist.backend.draw_line(x1: @x1, y1: @y1, x2: @x2, y2: @y2)
      end
    end
  end
end
