module Rubyplot
  module MagickWrapper
    module Plot
      class StackedBar < MagickWrapper::Artist
        class Geometry < MagickWrapper::Artist::Geometry
          attr_accessor :all_colors_array
          attr_accessor :plot_colors

          # Spacing factor applied between bars
          attr_accessor :bar_spacing

          attr_accessor :graph_width, :bar_width, :padding
          # Number of pixels between bar segments
          attr_accessor :segment_spacing, :column_count

          def initialize
            super
            @all_colors_array = Magick.colors
            @plot_colors = []
          end
        end
        # class Geometry
      end
      # class StackedBar
    end
    # module Plot
  end
  # module MagickWrapper
end
# module Rubyplot
