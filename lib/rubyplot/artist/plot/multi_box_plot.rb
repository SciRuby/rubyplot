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
        end

        def draw
        end
      end
    end
  end
end
