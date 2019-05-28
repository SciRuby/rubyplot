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
          @y_min = @box_plots.map(&:y_min).min - 1
          @x_max = @box_plots.map(&:x_max).max
          @y_max = @box_plots.map(&:y_max).max + 1

          configure_plot_geometry_data!
        end

        def draw
          @box_plots.each(&:draw)
        end

        private

        def configure_plot_geometry_data!
          @max_slot_width = 1.0
          @max_box_slot_width = @max_slot_width / @box_plots.size
          @padding = @max_box_slot_width * @spacing_ratio
          @box_plots.each_with_index do |box_plot, index|
            set_bar_properties! box_plot, index
          end
        end

        def set_bar_properties! box_plot, index
          box_plot.box_width = @max_box_slot_width - @padding * 2
          (@x_max).to_i.times do |i|
            box_plot.x_left_box[i] =  @max_box_slot_width * index + @max_slot_width * i +
              (@padding / 2)
          end
        end
      end
    end
  end
end
