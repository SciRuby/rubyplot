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
      }.freeze

      # Mapping between Rubyplot text types and GR text types.
      TEXT_FONT_MAP = {
        times_roman: GR::FONT_TIMES_ROMAN,
        times_italic: GR::FONT_TIMES_ITALIC,
        times_bold: GR::FONT_TIMES_BOLD,
        times_bold_italic: GR::FONT_TIMES_BOLD_ITALIC,
        helvetica: GR::FONT_HELVETICA,
        helvetica_oblique: GR::FONT_HELVETICA_OBLIQUE,
        helvetica_bold: GR::FONT_HELVETICA_BOLD,
        helvetica_bold_oblique: GR::FONT_HELVETICA_BOLD_OBLIQUE,
        courier: GR::FONT_COURIER,
        courier_oblique: GR::FONT_COURIER_OBLIQUE,
        courier_bold: GR::FONT_COURIER_BOLD,
        courier_bold_oblique: GR::FONT_COURIER_BOLD_OBLIQUE,
        symbol: GR::FONT_SYMBOL,
        bookman_light: GR::FONT_BOOKMAN_LIGHT,
        bookman_lightitalic: GR::FONT_BOOKMAN_LIGHT_ITALIC,
        bookman_demi: GR::FONT_BOOKMAN_DEMI,
        bookman_demi_italic: GR::FONT_BOOKMAN_DEMI_ITALIC,
        newcenturyschlbk_roman: GR::FONT_NEWCENTURYSCHLBK_ROMAN,
        newcenturyschlbk_italic: GR::FONT_NEWCENTURYSCHLBK_ITALIC,
        newcenturyschlbk_bold: GR::FONT_NEWCENTURYSCHLBK_BOLD,
        newcenturyschlbk_bold_italic: GR::FONT_NEWCENTURYSCHLBK_BOLD_ITALIC,
        avantgarde_book: GR::FONT_AVANTGARDE_BOOK,
        avantgarde_book_oblique: GR::FONT_AVANTGARDE_BOOK_OBLIQUE,
        avantgarde_demi: GR::FONT_AVANTGARDE_DEMI,
        avantgarde_demi_oblique: GR::FONT_AVANTGARDE_DEMI_OBLIQUE,
        palatino_roman: GR::FONT_PALATINO_ROMAN,
        palatino_italic: GR::FONT_PALATINO_ITALIC,
        palatino_bold: GR::FONT_PALATINO_BOLD,
        palatino_bold_italic: GR::FONT_PALATINO_BOLD_ITALIC,
        zapfchancery_medium_italic: GR::FONT_ZAPFCHANCERY_MEDIUM_ITALIC,
        zapfdingbats: GR::FONT_ZAPFDINGBATS
      }.freeze

      TEXT_PRECISION_MAP = {
        high: GR::TEXT_PRECISION_STRING,
        med: GR::TEXT_PRECISION_CHAR,
        low: GR::TEXT_PRECISION_STROKE
      }.freeze

      TEXT_DIRECTION_MAP = {
        left_right: GR::TEXT_PATH_RIGHT,
        right_left: GR::TEXT_PATH_LEFT,
        down_up: GR::TEXT_PATH_UP,
        up_down: GR::TEXT_PATH_DOWN
      }.freeze
        
      TEXT_HALIGNMENT_MAP = {
        normal: GR::TEXT_HALIGN_NORMAL,
        left: GR::TEXT_HALIGN_LEFT,
        center: GR::TEXT_HALIGN_CENTER,
        right: GR::TEXT_HALIGN_RIGHT
      }.freeze

      TEXT_VALIGNMENT_MAP = {
        normal: GR::TEXT_VALIGN_NORMAL,
        top: GR::TEXT_VALIGN_TOP,
        cap: GR::TEXT_VALIGN_CAP,
        half: GR::TEXT_VALIGN_HALF,
        base: GR::TEXT_VALIGN_BASE,
        bottom: GR::TEXT_VALIGN_BOTTOM
      }.freeze

      FILL_STYLE_MAP = {
        hollow: GR::FILLSTYLE_HOLLOW,
        solid: GR::FILLSTYLE_SOLID,
        pattern: GR::FILLSTYLE_PATTERN,
        hatch: GR::FILLSTYLE_HATCH
      }.freeze

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
          GR.setmarkertype(MARKER_TYPE_MAP[type])
          x.size.times do |i|
            GR.setmarkersize(size[i])
            GR.polymarker([x[i]], [y[i]])            
          end
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

      def draw_polygon(x:, y:, border_width:, border_type:, border_color:, fill_color:,
        fill_opacity:)
        within_window do
          draw_lines(x: x, y: y, width: border_width, color: border_color,
            type: border_type)
          if fill_color
            GR.settransparency(fill_opacity)
            GR.setfillintstyle(1)
            GR.setfillcolorind(to_gr_color(fill_color))
            GR.fillarea(x, y)
          end
        end
      end

      # Draw text on the canvas. Unlike other functions, this function does not
      # plot within a given window but directly uses the NDC for writing the text.
      # TODO: support text with special characters and latex symbols.
      def draw_text(text, color:, font: nil, size:,
        font_weight: nil, gravity: nil, abs_x:,abs_y:, rotation: nil,
        halign: nil, valign: nil, font_precision: :high, direction: :left_right,
        abs: true)
        within_window(abs) do
          if abs
            x = transform_x_ndc abs_x
            y = transform_y_ndc abs_y
          end

          GR.setcharup(*to_gr_rotation_vector(rotation))
          GR.setcharheight(to_gr_font_size(size))
          GR.settextpath(TEXT_DIRECTION_MAP[direction])
          GR.settextcolorind(to_gr_color(color))
          GR.settextfontprec(TEXT_FONT_MAP[font], TEXT_PRECISION_MAP[font_precision])
          GR.settextalign(TEXT_HALIGNMENT_MAP[halign], TEXT_VALIGNMENT_MAP[valign])
          GR.text(x, y, text)
        end
      end
      
      def draw_rectangle(x1:,y1:,x2:,y2:,border_color: :black,
        fill_color: nil, border_width: 1.0, border_type: :solid, abs: false)
        within_window(abs) do
          if abs
            x1 = transform_x_ndc x1
            x2 = transform_x_ndc x2
            y1 = transform_y_ndc y1
            y2 = transform_y_ndc y2
          end
          
          GR.setlinewidth(border_width)
          GR.setlinetype(LINE_TYPE_MAP[border_type])
          GR.setlinecolorind(to_gr_color(border_color))
          GR.drawrect(x1, x2, y1, y2)
          if fill_color
            GR.setfillintstyle(1)
            GR.setfillcolorind(to_gr_color(fill_color))
            GR.fillrect(x1, x2, y1, y2)
          end
        end
      end

      def draw_line
        
      end

      def draw_circle(x:, y:, radius:, border_width:, border_color:, border_type:,
        fill_color:, fill_opacity:)
        within_window do
          xmin = x - radius
          xmax = x + radius
          ymin = y - radius
          ymax = y + radius

          GR.setlinewidth(border_width)
          GR.setlinetype(LINE_TYPE_MAP[border_type])
          GR.setlinecolorind(to_gr_color(border_color))
          GR.drawarc(xmin, xmax, ymin, ymax, 0, 360)
          if fill_color
            GR.setfillintstyle(1)
            GR.setfillcolorind(to_gr_color(fill_color))
            GR.settransparency(fill_opacity)
            GR.fillarc(xmin, xmax, ymin, ymax, 0, 360)
          end
        end
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

      # FIXME
      def to_gr_rotation_vector rotation
        if rotation == -90.0
          [-1,0]
        else
          [0,1]
        end
      end

      # Transform font size expressed in terms of Rubyplot font size (pt.)
      # to GR font height that is expressed in terms of the height of the canvas.
      # FIXME: Figure out a way to do this.
      def to_gr_font_size rubyplot_font_size
        0.027 # GR default.
      end

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
        coord.to_f / @xspread
      end

      # Transform a Y quantity to Normalized Device Co-ordinates.
      def transform_y_ndc coord
        coord.to_f / @yspread
      end

      # Transform a quanitity that represents neither X nor Y co-ordinate into NDC.
      def transform_avg_ndc coord
        coord / ((@xspread + @yspread) / 2)
      end

      # Set the window on the canvas within which the plotting will take place
      # and then call the passed block for actual plotting.
      def within_window(abs=false, &block)
        if abs
          GR.setviewport(0,1,0,1)
          GR.setwindow(0,1,0,1)
        else
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
        end

        block.call
      end

      def draw_axes
        @axes_map.each_value do |v|
          axes = v[:axes]
          tick_length = transform_avg_ndc(axes.x_axis.major_ticks[0].length)
          within_window do
            GR.settransparency(1)
            GR.setcharheight(0.018)
            GR.setlinecolorind(to_gr_color(:black))
            GR.axes(
              (axes.x_axis.spread / axes.x_axis.major_ticks_count.to_f) /
                axes.x_axis.minor_ticks_count,
              (axes.y_axis.spread / axes.y_axis.major_ticks_count.to_f) /
                axes.y_axis.minor_ticks_count,
              axes.x_axis.min_val,
              axes.y_axis.min_val,
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
