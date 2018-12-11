module Rubyplot
  module Artist
    class LegendBox < Base
      MAX_WIDTH = 50.0
      MAX_HEIGHT = 30.0
      
      def initialize(axes, abs_x:, abs_y:)
        super(axes.backend, abs_x, abs_y)
        @axes = axes
        @legends = []
        configure_legends
      end

      def draw
        
      end

      private

      def configure_legends
        
      end
    end # class LegendBox
  end # module Artist 
end # module Rubyplot
