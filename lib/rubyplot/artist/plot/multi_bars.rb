module Rubyplot
  module Artist
    module Plot
      # Class for holding multiple Bar plot objects.
      # Terminoligies used:
      #
      # * A 'bar' is a single bar of a single bar plot.
      # * A 'slot' is a box within which multiple bars can be plotted.
      # * 'padding' is the total whitespace on the left and right of a slot.
      class MultiBars < Artist::Plot::Base
        # The max. width that each bar can occupy.
        attr_reader :max_bar_width

        def initialize(*args, bar_plots:)
          super(args[0])
          @bar_plots = bar_plots
          @x_min = @bar_plots.map(&:x_min).min
          @y_min = @bar_plots.map(&:y_min).min
          @x_max = @bar_plots.map(&:x_max).max
          @y_max = @bar_plots.map(&:y_max).max
          configure_plot_geometry_data!
          configure_x_ticks!
        end

        def normalize
          @bar_plots.each(&:normalize)
        end

        def draw
          @bar_plots.each(&:draw)
        end

        private

        def configure_plot_geometry_data!
          @num_max_slots = @bar_plots.map(&:num_bars).max
          @max_slot_width = (@axes.x_axis.abs_x2 - @axes.x_axis.abs_x1).abs / @num_max_slots
          # FIXME: figure out a way to specify inter-box space somehow.
          @spacing_ratio = @bar_plots[0].spacing_ratio
          @padding = @spacing_ratio * @max_slot_width
          @max_bars_width = @max_slot_width - @padding
          @bars_per_slot = @bar_plots.size
          @bar_plots.each_with_index do |bar, index|
            set_bar_dims bar, index
          end
        end

        def configure_x_ticks!
          @axes.num_x_ticks = @num_max_slots
          labels = @axes.x_ticks || Array.new(@num_max_slots, &:to_s)
          labels = labels[0...@axes.num_x_ticks] if labels.size != @axes.num_x_ticks
          @axes.x_ticks = labels.map.with_index do |label, i|
            Rubyplot::Artist::XTick.new(
              @axes,
              abs_x: @axes.abs_x + @axes.y_axis_margin + i * @max_slot_width + @max_slot_width / 2,
              abs_y: @axes.origin[1],
              label: label
            )
          end
        end

        def set_bar_dims bar_plot, index
          bar_plot.bar_width = @max_bars_width / @bars_per_slot
          @num_max_slots.times do |i|
            bar_plot.abs_x_left[i] = @axes.abs_x + @axes.y_axis_margin +
                                     i * @max_slot_width + @padding / 2 + index * bar_plot.bar_width
            bar_plot.abs_y_left[i] = @axes.origin[1] - @axes.x_axis.stroke_width
          end
        end
      end # class MultiBars
    end # module Plot
  end # module Artist
end # module Rubyplot
