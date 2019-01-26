require_relative '../../grruby.so'

module Rubyplot
  module Backend
    # Wrapper around a GR backend. Works differently than the Image Magick wrapper
    # since in GR there is no one-one mapping between Rubyplot artists and things
    # that are to be drawn on the backend.
    class GRWrapper < Base
      def initialize
        
      end

      def draw_x_axis
        
      end

      def draw_y_axis
        
      end

      def draw_text
        
      end

      def draw_line
        
      end

      def write
        
      end
    end # class GRWrapper
  end # module Backend
end # module Rubyplot
