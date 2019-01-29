require_relative '../../grruby.so'

module Rubyplot
  module Backend
    # Wrapper around a GR backend. Works differently than the Image Magick wrapper
    # since in GR there is no one-one mapping between Rubyplot artists and things
    # that are to be drawn on the backend.
    class GRWrapper < Base
      def initialize
        # Mapping between viewports and their respective Axes.
        @axes_maps = {}
      end

      def draw_x_axis(minor_ticks:, origin:, major_ticks:, tick_size:)
        @axes_maps[@active_axes] = {
          x_minor_ticks: minor_ticks,
          x_origin: origin,
          x_major_ticks: major_ticks,
          x_tick_size: tick_size
        }
      end

      def draw_y_axis(minor_ticks, origin:, major_ticks:, tick_size:)
        @axes_maps[@active_axes] = {
          y_minor_ticks: minor_ticks,
          y_origin: origin,
          y_major_ticks: major_ticks,
          y_tick_size: tick_size
        }
      end

      def draw_text
        
      end

      def draw_line
        
      end

      def draw
        draw_axes
      end

      def write file_name
        Rubyplot::GR.beginprint(file_name)
        draw
        Rubyplot::GR.endprint
      end

      private

      def within_window &block
        # set the viewport as per position of axes.
        # set the world co-ordinates as per ranges.
        # call block
      end

      def draw_axes
        @axes_maps.each do |k, v|
          @active_axes = k
          within_window do
            # Call Rubyplot::GR.axes with whatever args.
          end
        end
      end
    end # class GRWrapper
  end # module Backend
end # module Rubyplot
