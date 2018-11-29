module Rubyplot
  class Artist
    class Line
      def initialize axes, artist, x_values:,y_values:,color:
        @axes = axes
        @artist = artist
        @x_values = x_values
        @y_values = y_values
        generate_line_markers
      end

      def draw
        
      end

      private

    end # class Line
  end # class Artist
end # module Rubyplot
