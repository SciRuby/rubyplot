module Rubyplot
  module Artist
    module Plot
      class CandleStick < Artist::Plot::Base
        attr_accessor :lows
        attr_accessor :highs
        attr_accessor :opens
        attr_accessor :closes

        def initialize(*)
          super
          @lows = nil
          @highs = nil
          @opens = nil
          @closes = nil
        end

        def process_data
          
        end

        def draw
        end
      end
    end
  end
end
