module Rubyplot
  module Artist
    class YAxis < Axis::Base
      def initialize(*)
        super
        @x1 = @artist.graph_left
        @y1 = @artist.graph_height + @artist.graph_top
        @x2 = @artist.graph_left
        @y2 = @artist.graph_top
      end
    end # class YAxis
  end # class Artist
end # module Rubyplot
