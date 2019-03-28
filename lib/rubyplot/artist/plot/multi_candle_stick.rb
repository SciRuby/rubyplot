module Rubyplot
  module Artist
    module Plot
      class MultiCandleStick < Artist::Plot::Base
        def initialize(*args, candle_sticks:)
          super(args[0])
          @candle_sticks = candle_sticks
          @spacing_ratio = 0.1
        end

        def process_data
          @candle_sticks.each(&:process_data)
          @y_min = @candle_sticks.map(&:y_min).min
          @y_max = @candle_sticks.map(&:y_max).max
          @x_min = 0
          @x_max = @candle_sticks.map(&:x_max).max
          @max_slot_width = 1.0
          @candles_per_slot = @candle_sticks.size
          @max_candle_width = @max_slot_width / @candles_per_slot
          @candle_sticks.each_with_index do |candle_stick, index|
            set_bar_dims candle_stick, index
          end
        end

        def draw
          
        end

        private

        def set_bar_dims candle_stick, index
          candle_stick.bar_width = (@max_slot_width - @candles_per_slot * @spacing_ratio) /
            @candles_per_slot
          @x_max.to_i.times do |i|
            candle_stick.x_left_candle[i] = @max_slot_width * i + 
              candle_stick.bar_width * index + @spacing_ratio * @max_candle_width * i +
              (@spacing_ratio/2) * @max_candle_width
            candle_stick.x_low_stick[i] = @max_slot_width * i +
              @max_candle_width * index + @max_candle_width / 2
          end
        end
      end # class MultiCandlestick
    end # module Plot
  end # module Artist
end # module Rubyplot
