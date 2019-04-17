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
        @file_name = nil
        @xspread = Rubyplot::MAX_X.abs + Rubyplot::MIN_X.abs
        @yspread = Rubyplot::MAX_Y.abs + Rubyplot::MIN_Y.abs
      end

      # Draw X axis for the currently selected Axes.
      def draw_x_axis(minor_ticks:, origin:, major_ticks:, tick_size:)
        @axes_maps[@active_axes] = {
          x_minor_ticks: minor_ticks,
          x_origin: origin,
          x_major_ticks: major_ticks,
          x_tick_size: tick_size
        }
      end

      # Draw Y axis for currently selected Axes.
      def draw_y_axis(minor_ticks:, origin:, major_ticks:, tick_size:)
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

      def init_output_device file_name
        @file_name = file_name
        Rubyplot::GR.beginprint file_name
      end

      def stop_output_device
        Rubyplot::GR.endprint
      end

      def write file_name
        draw
      end

      private

      # Set the window on the canvas within which the plotting will take place
      # and then call the passed block for actual plotting.
      def within_window &block
        vp_min_x = (@active_axes.abs_x + @active_axes.left_spacing) / @xspread
        vp_min_y = (@active_axes.abs_y + @active_axes.bottom_spacing) / @yspread
        vp_max_x = (@active_axes.abs_x + @active_axes.width -
          @active_axes.right_spacing) / @xspread
        vp_max_y = (@active_axes.abs_y + @active_axes.height -
          @active_axes.top_spacing) / @yspread
        
        Rubyplot::GR.setviewport(vp_min_x, vp_max_x, vp_min_y, vp_max_y)
        Rubyplot::GR.setwindow(
          @active_axes.xrange[0],
          @active_axes.xrange[1],
          @active_axes.yrange[0],
          @active_axes.yrange[1]
        )
        block.call
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
