module Rubyplot
  module Artist
    module Plot
      class Bar < Artist::Plot::Base
        # Space between the columns.
        attr_accessor :bar_spacing
        # Number between 0 and 1.0 denoting spacing between the bars.
        # 0.0 means no spacing at all 1.0 means that each bars' width
        # is nearly 0 (so each bar is a simple line with no X dimension).
        attr_reader :spacing_factor
        def initialize(*)
          super
          @spacing_factor = 0.9
        end

        # Set the spacing factor for this bar plot.
        def spacing_factor=(s_f)
          raise ValueError, '@spacing_factor must be between 0.00 and 1.00' unless
            (s_f >= 0) && (s_f <= 1)

          @spacing_factor = s_f
        end

        def draw
          super
          return unless @axes.geometry.has_data
        end
      end
      # class Bar
    end
    # module Plot
  end
  # module Artist
end
# module Rubyplot
