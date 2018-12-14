module Rubyplot
  module MagickWrapper
    module Plot
      class Area < MagickWrapper::Artist
        class Geometry < MagickWrapper::Artist::Geometry
          attr_accessor :spacing_factor
          def initialize(*)
            super
            @spacing_factor = 0.9
          end
        end
        # class Geometry
      end
      # class Area
    end
    # module Plot
  end
  # module MagickWrapper
end
# module Rubyplot
