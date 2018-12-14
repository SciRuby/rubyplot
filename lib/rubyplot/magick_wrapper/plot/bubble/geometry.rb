module Rubyplot
  module MagickWrapper
    module Plot
      class Bubble < MagickWrapper::Plot::Scatter
        class Geometry < MagickWrapper::Plot::Scatter::Geometry
          attr_accessor :all_colors_array
          attr_accessor :z_data
          attr_accessor :plot_colors
          attr_accessor :max_x_value
          attr_accessor :min_x_value

          def initialize
            super
            @all_colors_array = Magick.colors
            @plot_colors = []
            @z_data = []
            @max_x_value = nil
            @min_x_value = nil
          end
        end
        # class Geometry
      end
      # class Bar
    end
    # module Plot
  end
  # module MagickWrapper
end
# module Rubyplot
