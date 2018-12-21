module Rubyplot
  module Artist
    module Plot
      class MultiStackedBar < Artist::Plot::Base
        def initialize(*, stacked_bars:)
          super
          @stacked_bars = stacked_bars
          @x_min = @stacked_bars.map(&:x_min).min
          @y_min = @stacked_bars.map(&:y_min).min
          @x_max = @stacked_bars.map(&:x_max).max
          @y_max = @stacked_bars.map(&:y_max).max
          configure_plot_geometry_data
          configure_x_ticks
        end

        def draw
          
        end

        private

        def configure_plot_geometry_data
          @num_max_slots = @stacked_bars.map { |bar| bar.num_bars }.max
          @max_slot_width = (@axes.x_axis.abs_x2 - @axes.x_axis.abs_x1).abs / @num_max_slots
          @spacing_ratio = @stacked_bars[0].spacing_ratio
          @padding = @spacing_ratio * @max_slot_width
          @max_bars_width = @max_slot_width - @padding
          @num_max_stacks = @stacked_bars.size
          @stacked_bars.each_with_index do |bar, index|
            set_bar_dims bar, index
          end
        end

        def configure_x_ticks
          
        end

        def set_bar_dims bar, plot_index
          bar.bar_width = @max_bars_width
          bar.num_bars.times do |i|
            bar.abs_x_left[i] = @axes.abs_x + @axes.y_axis_margin +
                                i * @max_bars_width  + @padding / 2
            bar.abs_y_left[i] = 
          end
        end
      end # class StackedBar
    end # module Plot
  end # module Artist
end # module Rubyplot
