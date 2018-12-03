require_relative 'base'

module Rubyplot
  module Artist
    class XAxis < Axis::Base
      def initialize(*)
        super
        @x1 = @axes.graph_left
        @y1 = @axes.graph_height + @axes.graph_top
        @x2 = @axes.graph_width
        @y2 = @axes.graph_height + @axes.graph_top
        @x_ticks = []
        @major_ticks_count = ((@x2 - @x1) / @major_ticks_distance).to_i
        populate_major_x_ticks
        set_title
      end

      def draw
        super
        @x_ticks.each(&:draw)
        @title.draw if @title
      end

      private

      def populate_major_x_ticks
        value_distance = @max_val - @min_val
        @major_ticks_count.times do |count|
          count += 1
          @x_ticks << Rubyplot::Artist::XTick.new(
            @axes,
            x: count * @major_ticks_distance + @x1,
            y: @y1,
            label: count * value_distance,
            length: 6,
            label_distance: 10
          )
        end
      end

      def set_title
        if @title
          @title = Rubyplot::Artist::Text.new(
            @title,
            self,
            pointsize: @axes.marker_font_size * @axes.scale,
            width: @axes.geometry.raw_columns,
            height: 1.0,
            y: @axes.graph_bottom + Artist::Axes::LABEL_MARGIN*2 + @axes.marker_caps_height,
            x: @axes.graph_left + (@x2-@x1)/2.0,
            gravity: :center
          )
        end
      end
    end # class XAxis
  end # class Artist
end # module Rubyplot
