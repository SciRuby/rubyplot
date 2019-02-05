require_relative '../../grruby.so'

module Rubyplot
  module Backend
    # Wrapper around a GR backend. Works differently than the Image Magick wrapper
    # since in GR there is no one-one mapping between Rubyplot artists and things
    # that are to be drawn on the backend.
    class GRWrapper < Base
      # Mapping Rubyplot markers to GR marker constants.
      MARKER_MAP = {
        dot: GR::MARKERTYPE_DOT,
        plus: GR::MARKERTYPE_PLUS,
        asterisk: GR::MARKERTYPE_ASTERISK,
        circle: GR::MARKERTYPE_CIRCLE,
        diagonal_cross: GR::MARKERTYPE_DIAGONAL_CROSS
      }.freeze
      
      def initialize
        @axes_maps = {} # Mapping between viewports and their respective Axes.
        @file_name = nil
        @xspread = Rubyplot::MAX_X.abs + Rubyplot::MIN_X.abs
        @yspread = Rubyplot::MAX_Y.abs + Rubyplot::MIN_Y.abs
      end

      # Draw X axis for the currently selected Axes.
      #
      # @param minor_ticks [[Rubyplot::Artist::XTick]] Array of XTick objects representing
      #   minor ticks.
      # @param origin [Numeric] X co-ordinate value that is the origin of the X axis.
      # @param major_ticks [[Rubyplot::Artist::XTick]] Array of XTick objects representing
      #  major ticks.
      # @param major_ticks_count [Integer] Number of major ticks to plot.
      def draw_x_axis(minor_ticks:, origin:, major_ticks:, major_ticks_count:)
        @axes_maps[@active_axes] = {
          x_minor_ticks: minor_ticks,
          x_origin: origin,
          x_major_ticks: major_ticks,
          x_major_ticks_count: major_ticks_count
        }
      end

      # Draw Y axis for currently selected Axes.
      def draw_y_axis(minor_ticks:, origin:, major_ticks:, major_ticks_count:)
        @axes_maps[@active_axes] = {
          y_minor_ticks: minor_ticks,
          y_origin: origin,
          y_major_ticks: major_ticks,
          y_major_ticks_count: major_ticks_count
        }
      end
      
      def draw_markers(x:, y:, marker_type:, marker_color:, marker_size:)
        within_window do
          rgb = Rubyplot::Color::COLOR_INDEX[marker_color].match(/#(..)(..)(..)/)
          GR.setmarkercolorind(
            GR.inqcolorfromrgb(
              rgb[1].hex.to_f/255.0,
              rgb[2].hex.to_f/255.0,
              rgb[3].hex.to_f/255.0)
          )
          GR.setmarkersize(1)
          GR.setmarkertype(MARKER_MAP[marker_type])
          GR.polymarker(x, y)
        end
      end

      def draw_text(text,font_color:,font: nil,font_size:,
        font_weight: nil, gravity: nil,
        x:,y:,rotation: nil, stroke: nil)
        
      end

      def draw_rectangle(x1:,y1:,x2:,y2:,border_color: nil,stroke: nil,
        fill_color: nil, stroke_width: nil)
        
      end

      def draw_line
        
      end

      def draw
        draw_axes
      end

      def init_output_device file_name
        @file_name = file_name
        Rubyplot::GR.clearws
      end

      def stop_output_device
        Rubyplot::GR.updatews
        sleep(10)
      end

      def write file_name
        draw
      end

      private

      # Transform a X quantity to Normalized Device Co-ordinates.
      def transform_x_ndc coord
        coord / @xspread
      end

      # Transform a Y quantity to Normalized Device Co-ordinates.
      def transform_y_ndc coord
        coord / @yspread
      end

      # Transform a quanitity that represents neither X nor Y co-ordinate into NDC.
      def transform_avg_ndc coord
        coord / ((@xspread + @yspread) / 2)
      end

      # Set the window on the canvas within which the plotting will take place
      # and then call the passed block for actual plotting.
      def within_window &block
        vp_min_x = (@active_axes.abs_x + @active_axes.left_margin) / @xspread
        vp_min_y = (@active_axes.abs_y + @active_axes.bottom_margin) / @yspread
        vp_max_x = (@active_axes.abs_x + @active_axes.width -
          @active_axes.right_margin) / @xspread
        vp_max_y = (@active_axes.abs_y + @active_axes.height -
          @active_axes.top_margin) / @yspread
        
        GR.setviewport(vp_min_x, vp_max_x, vp_min_y, vp_max_y)
        GR.setwindow(
          @active_axes.x_range[0],
          @active_axes.x_range[1],
          @active_axes.y_range[0],
          @active_axes.y_range[1]
        )
        block.call
      end

      def draw_axes
        @axes_maps.each do |axes, v|
          tick_length = transform_avg_ndc(axes.x_axis.major_ticks[0].length)
          within_window do
            GR.axes(
              (axes.x_axis.spread / axes.x_axis.major_ticks_count.to_f) /
                axes.x_axis.minor_ticks_count,
              (axes.y_axis.spread / axes.y_axis.major_ticks_count.to_f) /
                axes.y_axis.minor_ticks_count,
              axes.origin[0],
              axes.origin[1],
              axes.x_axis.minor_ticks_count,
              axes.y_axis.minor_ticks_count,
              -tick_length
            )
          end
        end
      end
    end # class GRWrapper
  end # module Backend
end # module Rubyplot
