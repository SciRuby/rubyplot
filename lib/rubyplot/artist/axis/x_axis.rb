require_relative 'base'

module Rubyplot
  module Artist
    class XAxis < Axis::Base
      def initialize(*)
        super
        @abs_x1 = @axes.origin[0]
        @abs_y1 = @axes.origin[1]
        @abs_x2 = @axes.abs_x + @axes.width - @axes.y_axis_margin
        @abs_y2 = @axes.origin[1]
        @major_ticks_count = 5
        @major_ticks_distance = (@abs_x2 - @abs_x1) / @major_ticks_count
        @x_ticks = []
        configure_axis_line
        populate_major_x_ticks
        configure_title
      end

      def draw
        @line.draw
        @x_ticks.each(&:draw)
        @title.draw
      end

      private

      def configure_axis_line
        @line = Rubyplot::Artist::Line2D.new(
          self, abs_x1: @abs_x1, abs_y1: @abs_y1, abs_x2: @abs_x2, abs_y2: @abs_y2
        )
        # stroke_width: @stroke_width)
      end

      def populate_major_x_ticks
        value_distance = @max_val / @major_ticks_count.to_f
        @major_ticks_count.times do |count|
          count += 1
          @x_ticks << Rubyplot::Artist::XTick.new(
            @axes,
            abs_x: count * @major_ticks_distance + @abs_x1,
            abs_y: @abs_y1,
            label: (count * value_distance),
            length: 6,
            label_distance: 10
          )
        end
      end

      def configure_title
        @title = Rubyplot::Artist::Text.new(
          @title,
          self,
          pointsize: @axes.marker_font_size,
          abs_y: @axes.origin[1] + 20,
          abs_x: @axes.origin[0] + (@abs_x2 - @abs_x1)/2
        )
      end
    end
    # class XAxis
  end
  # class Artist
end
# module Rubyplot
