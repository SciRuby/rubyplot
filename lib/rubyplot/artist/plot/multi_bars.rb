module Rubyplot
  module Artist
    module Plot
      # Class for holding multiple Bar plot objects.
      class MultiBars < Artist::Plot::Base
        # The max. width that each bar can occupy.
        attr_reader :max_bar_width

        def initialize(*, bar_plots:)
          super
          @bar_plots = bar_plots
        end

        def draw
          configure_plot_geometry_data
          configure_x_ticks
          broadcast_to_bar_plots
          @bar_plots.each(&:draw)
        end

        private

        def configure_plot_geometry_data
          @bar_plots.map(&:num_bars).max
          @max_bar_width = (@axes.x_axis.abs_x2 - @axes.x_axis.abs_x1).abs
          @bar_plots.each do |bar|
            set_bar_coords bar
          end
        end

        def configure_x_ticks
          if @axes.x_ticks # user supplied ticks

          end
        end

        def bar_coords_set bar_plot; end
      end
      # class MultiBars
    end
    # module Plot
  end
  # module Artist
end
# module Rubyplot
