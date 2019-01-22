require_relative '../../grruby.so'

module Rubyplot
  module Backend
    # Wrapper around a GR backend. Uses GR's default co-ordinate system.
    #  The lower left corner is (0,0) and the upper right corner is (1,1).
    #
    # Unlike the GR wrapper, the backend stores the state of the drawing
    #   with minimal dependence on GR for state storage because of GR's
    #   procedural nature.
    class GRWrapper < Base

      # Set the max and min co-ordinates for this GR window.
      def initialize
        Rubyplot::GR.setwindow(Rubyplot::MIN_X, Rubyplot::MAX_X,
                               Rubyplot::MIN_Y, Rubyplot::MAX_Y)
      end
    end # class GRWrapper
  end # module Backend
end # module Rubyplot
