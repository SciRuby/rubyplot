require_relative 'base'

module Rubyplot
  class Artist
    class XAxis < Axis::Base
      def initialize(*)
        super
        @x1 = @artist.graph_left
        @y1 = @artist.graph_height + @artist.graph_top
        @x2 = @artist.graph_width
        @y2 = @artist.graph_height + @artist.graph_top
        @x_ticks = []
        @major_ticks_count = ((@x2 - @x1) / @major_ticks_distance).to_i
        populate_major_x_ticks
      end

      def draw
        super
        @x_ticks.each(&:draw)
      end

      private

      def populate_major_x_ticks
        value_distance = @max_val - @min_val
        @major_ticks_count.times do |count|
          count += 1
          @x_ticks << Rubyplot::Artist::XTick.new(
            @artist,
            x: count * @major_ticks_distance + @x1,
            y: @y1,
            label: count * value_distance,
            length: 6,
            label_distance: 2
          )
        end
      end
    end # class XAxis
  end # class Artist
end # module Rubyplot
