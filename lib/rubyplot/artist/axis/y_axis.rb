module Rubyplot
  module Artist
    class YAxis < Axis::Base
      def initialize(*)
        super
        @x1 = @axes.graph_left
        @y1 = @axes.graph_height + @axes.graph_top
        @x2 = @axes.graph_left
        @y2 = @axes.graph_top
        if @title
          @title = Rubyplot::Artist::Text.new(
            @title,
            self,
            rotation: -90.0,
            gravity: :center,
            x: @axes.geometry.left_margin + @axes.marker_caps_height/2.0,
            y: @axes.graph_top + @axes.graph_height/2.0,
            width: 1.0,
            height: @axes.raw_rows,
            pointsize: @axes.marker_font_size * @axes.scale
          )
        end
      end

      def draw
        super
        @title.draw
      end
    end # class YAxis
  end # class Artist
end # module Rubyplot
