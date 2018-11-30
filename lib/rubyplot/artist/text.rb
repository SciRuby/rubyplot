module Rubyplot
  class Artist
    class Text
      # (X,Y) of upper left corner of the rectangle.
      attr_reader :x, :y, :height, :width
      
      def initialize(artist, x:, y:, height:, width:)
        @artist, @x, @y, @height, @width = artist, x, y, height, width
      end

      def draw
        
      end
    end # class Text
  end # class Artist
end # module Rubyplot
