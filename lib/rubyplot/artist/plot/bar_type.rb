module Rubyplot
  module Artist
    module Plot
      class BarType < Artist::Plot::Base

        def initialize(*)
          super
          @spacing_ratio = 0.1
          @abs_x_left = []
          @abs_y_left = []
          @rectangles = []
        end

        def data y_values
          super(Array(0...(y_values.size)), y_values)
        end
        
        def num_bars
          @data[:y_values].size
        end

        def draw
          setup_bar_rectangles
          @rectangles.each(&:draw)
        end

        protected

        
      end # class BarType
    end # module Plot
  end # module Artist
end # module Rubyplot
