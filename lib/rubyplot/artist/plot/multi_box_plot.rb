module Rubyplot
  module Artist
    module Plot
      class MultiBoxPlot < Artist::Plot::Base
        def initialize(*args, box_plots:)
          super(args[0])
          @box_plots = box_plots
          @spacing_ratio = 0.1
        end

        def process_data
          @box_plots.each(&:process_data)
          @x_min = @box_plots.map(&:x_min).min
          @y_min = @box_plots.map(&:y_min).min
          @x_max = @box_plots.map(&:x_max).max
          @y_max = @box_plots.map(&:y_max).max

          configure_plot_geometry_data!
        end

        def draw
        end

        private

        def configure_plot_geometry_data!
          @max_slot_width = 1.0
          @max_box_slot_width = @max_slot_width / @box_plots.size
          @box_plots.each_with_index do |box_plot, index|
            set_bar_properties! box_plot, index
          end
        end

        def set_bar_properties! box_plot, index
          box_plot.bar_width = (@max_slot_width - @padding * @box_plots.size) /
            @box_plots.size
          (@x_max-1).to_i.times do |i|

          end
        end
      end
    end
  end
end
