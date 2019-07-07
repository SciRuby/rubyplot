module Rubyplot
  module Artist
    class YAxis < Axis::Base
      def initialize(*)
        super
      end

      def draw
        configure_title
        Rubyplot.backend.draw_y_axis(
          origin: @axes.origin[1],
          major_ticks: @major_ticks,
          minor_ticks: @minor_ticks,
          major_ticks_count: @major_ticks_count,
          minor_ticks_count: @minor_ticks_count
        )
        @texts.each(&:draw)
      end

      private

      def configure_title
        @title = 'Y axis' if @title == ''
        @texts << Rubyplot::Artist::Text.new(
          @title,
          self,
          rotation: -90.0,
          abs_x: @axes.abs_x,
          abs_y: @axes.abs_y + @axes.height / 2,
          size: @title_font_size
        )
      end
    end # class YAxis
  end # class Artist
end # module Rubyplot
