require_relative '../../grruby.so'

module Rubyplot
  module Backend
    # Wrapper around a GR backend. Works differently than the Image Magick wrapper
    # since in GR there is no one-one mapping between Rubyplot artists and things
    # that are to be drawn on the backend.
    class GRWrapper < Base
      # Mapping Rubyplot markers to GR marker constants.
      MARKER_TYPE_MAP = {
        dot: GR::MARKERTYPE_DOT,
        plus: GR::MARKERTYPE_PLUS,
        asterisk: GR::MARKERTYPE_ASTERISK,
        circle: GR::MARKERTYPE_CIRCLE,
        diagonal_cross: GR::MARKERTYPE_DIAGONAL_CROSS,
        solid_circle: GR::MARKERTYPE_SOLID_CIRCLE,
        triangle_up: GR::MARKERTYPE_TRIANGLE_UP,
        solid_triangle_up: GR::MARKERTYPE_SOLID_TRI_UP,
        triangle_down: GR::MARKERTYPE_TRIANGLE_DOWN,
        solid_triangle_down: GR::MARKERTYPE_SOLID_TRI_DOWN,
        square: GR::MARKERTYPE_SQUARE,
        solid_square: GR::MARKERTYPE_SOLID_SQUARE,
        bowtie: GR::MARKERTYPE_BOWTIE,
        solid_bowtie: GR::MARKERTYPE_SOLID_BOWTIE,
        hglass: GR::MARKERTYPE_HGLASS,
        solid_hglass: GR::MARKERTYPE_SOLID_HGLASS,
        diamond: GR::MARKERTYPE_DIAMOND,
        solid_diamond: GR::MARKERTYPE_SOLID_DIAMOND,
        star: GR::MARKERTYPE_STAR,
        solid_star: GR::MARKERTYPE_SOLID_STAR,
        tri_up_down: GR::MARKERTYPE_TRI_UP_DOWN,
        solid_tri_right: GR::MARKERTYPE_SOLID_TRI_RIGHT,
        solid_tri_left: GR::MARKERTYPE_SOLID_TRI_LEFT,
        hollow_plus: GR::MARKERTYPE_HOLLOW_PLUS,
        solid_plus: GR::MARKERTYPE_SOLID_PLUS,
        pentagon: GR::MARKERTYPE_PENTAGON,
        hexagon: GR::MARKERTYPE_HEXAGON,
        heptagon: GR::MARKERTYPE_HEPTAGON,
        octagon: GR::MARKERTYPE_OCTAGON,
        star_4: GR::MARKERTYPE_STAR_4,
        star_5: GR::MARKERTYPE_STAR_5,
        star_6: GR::MARKERTYPE_STAR_6,
        star_7: GR::MARKERTYPE_STAR_7,
        star_8: GR::MARKERTYPE_STAR_8,
        vline: GR::MARKERTYPE_VLINE,
        hline: GR::MARKERTYPE_HLINE,
        omark: GR::MARKERTYPE_OMARK
      }.freeze

      # Mapping between rubyplot line types and GR line types.
      LINE_TYPE_MAP = {
        solid: GR::LINETYPE_SOLID,
        dashed: GR::LINETYPE_DASHED,
        dotted: GR::LINETYPE_DOTTED,
        dashed_dotted: GR::LINETYPE_DASHED_DOTTED,
        dash_2_dot: GR::LINETYPE_DASH_2_DOT,
        dash_3_dot: GR::LINETYPE_DASH_3_DOT,
        long_dash: GR::LINETYPE_LONG_DASH,
        long_short_dash: GR::LINETYPE_LONG_SHORT_DASH,
        spaced_dash: GR::LINETYPE_SPACED_DASH,
        spaced_dot: GR::LINETYPE_SPACED_DOT,
        double_dot: GR::LINETYPE_DOUBLE_DOT,
        triple_dot: GR::LINETYPE_TRIPLE_DOT
      }

      def initialize
        @axes_map = {} # Mapping between viewports and their respective Axes.
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
        @axes_map[@active_axes.object_id] = {
          axes: @active_axes,
          x_minor_ticks: minor_ticks,
          x_origin: origin,
          x_major_ticks: major_ticks,
          x_major_ticks_count: major_ticks_count
        }
      end

      # Draw Y axis for currently selected Axes.
      def draw_y_axis(minor_ticks:, origin:, major_ticks:, major_ticks_count:)
        @axes_map[@active_axes.object_id] = {
          axes: @active_axes,
          y_minor_ticks: minor_ticks,
          y_origin: origin,
          y_major_ticks: major_ticks,
          y_major_ticks_count: major_ticks_count
        }
      end
      
      def draw_markers(x:, y:, type:, color:, size:)
        within_window do
          GR.setmarkercolorind(to_gr_color(color))
          GR.setmarkersize(size)
          GR.setmarkertype(MARKER_TYPE_MAP[type])
          GR.polymarker(x, y)
        end
      end

      def draw_lines(x:, y:, width:, type:, color:)
        within_window do
          GR.setlinewidth(width)
          GR.setlinetype(LINE_TYPE_MAP[type])
          GR.setlinecolorind(to_gr_color(color))
          GR.polyline(x, y)
        end
      end

      def draw_text(text,font_color:,font: nil,font_size:,
        font_weight: nil, gravity: nil,
        abs_x:,abs_y:,rotation: nil, stroke: nil)
        
      end

      def draw_rectangle(x1:,y1:,x2:,y2:,border_color: nil,stroke: nil,
        fill_color: nil, stroke_width: nil)
        
      end

      def draw_line
        
      end

      def draw
        draw_axes
      end

      def init_output_device file_name, device: :file
        @file_name = file_name
        @output_device = device
        Rubyplot::GR.clearws
        
        if @output_device == :file
          Rubyplot::GR.beginprint(file_name)
        end
      end

      def stop_output_device
        if @output_device == :file
          Rubyplot::GR.endprint
        elsif @output_device == :window
          Rubyplot::GR.updatews
        end
        flush
      end

      def write file_name
        draw
      end

      # Refresh this backend and remove all previously set data.
      def flush
        @axes_map = {}
        @file_name = nil
      end

      private

      def to_gr_color color
        r,g,b = to_rgb color
        GR.inqcolorfromrgb(r, g, b)
      end
      
      def to_rgb color
        match = Rubyplot::Color::COLOR_INDEX[color].match(/#(..)(..)(..)/)
        r, g, b = match[1], match[2], match[3]
        [r.hex.to_f/255.0, g.hex.to_f/255.0, b.hex.to_f/255.0]
      end

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
        @axes_map.each_value do |v|
          axes = v[:axes]
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
