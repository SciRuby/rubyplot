module Rubyplot
  module Artist
    class Axis
      class Base
        # Length of the arrow after the last major tick.
        FINISH_ARROW_LENGTH = 2.0

        # Array of Rubyplot::XTick objects representing major ticks.
        attr_accessor :major_ticks
        # Number of major ticks to be plotted.
        attr_accessor :major_ticks_count
        attr_accessor :minor_ticks # TODO
        # Number of minor ticks between each major tick.
        attr_reader :minor_ticks_count
        # Title (or label) given to this Axis.
        attr_accessor :title
        # The minimum value that this Axis contains.
        attr_accessor :min_val
        # The maximum value that this Axis contains.
        attr_accessor :max_val
        # Font size of title.
        attr_accessor :title_font_size
        # Font of the title.
        attr_accessor :title_font

        def initialize axes
          @axes = axes
          @title = ''
          @min_val = nil
          @max_val = nil
          @major_ticks_count = 5
          @minor_ticks_count = 2
          @texts = []
          @lines = []
          @major_ticks = nil
          @minor_ticks = nil
        end

        def spread
          (@max_val - @min_val).abs
        end
      end # class Base
    end # class Axis
  end # class Artist
end # module Rubyplot
