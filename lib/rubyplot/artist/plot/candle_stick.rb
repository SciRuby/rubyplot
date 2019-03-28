module Rubyplot
  module Artist
    module Plot
      class CandleStick < Artist::Plot::Base
        attr_accessor :lows
        attr_accessor :highs
        attr_accessor :opens
        attr_accessor :closes
        attr_accessor :bar_width
        attr_accessor :x_left_candle, :y_left_candle
        attr_accessor :x_low_stick, :y_low_stick

        attr_reader :x_min, :x_max, :y_min, :y_max

        def initialize(*)
          super
          @lows = []
          @highs = []
          @opens = []
          @closes = []
          @x_left_candle = []
          @y_left_candle = []
          @x_low_stick = []
          @y_low_stick = []
        end

        def process_data
          if @lows.size != @highs.size != @opens.size != @closes.size
            raise Rubyplot::SizeError, "all given parameters must be of equal size."
          end
          @y_min = [@lows.min, @highs.min, @opens.min, @closes.min].min
          @y_max = [@lows.max, @highs.max, @opens.max, @closes.max].max
          @x_min = 0
          @x_max = @lows.size
        end

        def draw
        end
      end
    end
  end
end
