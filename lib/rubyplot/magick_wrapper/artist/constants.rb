module Rubyplot
  module MagickWrapper
    class Artist
      module Constants
        # Used for navigating the array of data to plot
        DATA_LABEL_INDEX = 0
        DATA_VALUES_INDEX = 1
        DATA_COLOR_INDEX = 2
        DATA_VALUES_X_INDEX = 3

        # Space around text elements. Mostly used for vertical spacing.
        # This way the vertical text doesn't overlap.
        LEGEND_MARGIN = TITLE_MARGIN = 20.0
        LABEL_MARGIN = 10.0
        DEFAULT_MARGIN = 20.0

        DEFAULT_TARGET_WIDTH = 800

        THOUSAND_SEPARATOR = ','.freeze
      end
    end
  end
end
