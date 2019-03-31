module Rubyplot
  module Artist
    module Plot
      class CandleStick < Artist::Plot::Base
        attr_accessor :lows
        attr_accessor :highs
        attr_accessor :opens
        attr_accessor :closes
        attr_accessor :bar_width
        attr_accessor :x_left_candle
        attr_accessor :x_low_stick
        attr_accessor :border_color

        attr_reader :x_min, :x_max, :y_min, :y_max

        def initialize(*)
          super
          @lows = []
          @highs = []
          @opens = []
          @closes = []
          @x_left_candle = []
          @x_low_stick = []
          @border_color = :black
        end

        def process_data
          if @lows.size != @highs.size || @opens.size != @closes.size
            raise Rubyplot::SizeError, "all given parameters must be of equal size."
          end
          @y_min = [@lows.min, @highs.min, @opens.min, @closes.min].min
          @y_max = [@lows.max, @highs.max, @opens.max, @closes.max].max
          @x_min = 0
          @x_max = @lows.size
        end

        def draw
          @x_low_stick.each_with_index do |ix_stick, i|
            Rubyplot::Artist::Line2D.new(
              self,
              x1: ix_stick,
              y1: @lows[i],
              x2: ix_stick,
              y2: @highs[i]
            ).draw
          end
          @x_left_candle.each_with_index do |ix_candle, i|
            Rubyplot::Artist::Rectangle.new(
              self,
              x1: ix_candle,
              y1: @opens[i],
              x2: ix_candle + @bar_width,
              y2: @closes[i],
              border_color: @border_color,
              fill_color: @data[:color]
            ).draw
          end
        end
      end
    end
  end
end
