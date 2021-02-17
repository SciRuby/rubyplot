require 'tk'

module Rubyplot
  module Backend
    class TkCanvasWrapper < Base
      def tk_canvas
        @show_context
      end

      def show
      end

      # Write text anywhere on the canvas. abs_x and abs_y should be specified in terms
      #   of Rubyplot Artist Co-ordinates.
      #
      # @param text [String] String of text to write.
      # @param abs_x [Numeric] X co-ordinate of the text in Rubyplot Artist Co-ordinates.
      # @param abs_y [Numeric] Y co-ordinate of the text in Rubyplot Aritst Co-ordinates.
      # @param font_color [Symbol] Color of the font from Rubyplot::Colors.
      # @param font [Symbol] Name of the font.
      # @param size [Numeric] Size of the font.
      # @param font_weight [Symbol] Measure of 'bigness' of the font.
      # @param rotation [Numeric] Angle between 0 and 360 degrees signifying rotation of text.
      # @param halign [Symbol] Horizontal alignment of the text from Artist::Text::HAlignment.
      # @param valign [Symbol] Vertical alignment of the text from Artist::Text::VAlignment
      def draw_text(text,color:,font: nil,size:,
                    font_weight: nil, halign: nil, valign: nil,
                    abs_x:, abs_y:,rotation: nil, stroke: nil, abs: true)
        x = x_to_tk(abs_x, abs: abs)
        y = y_to_tk(abs_y, abs: abs)
        TkcText.new(tk_canvas, x, y, text: text, anchor: text_align_to_tk(halign, valign),
                    font: font_to_tk(font, size, font_weight), fill: color_to_tk(color), angle: rotation_to_tk(rotation))
      end

      # Draw a rectangle with optional fill.
      #
      # @param x1 [Numeric] Lower left X co-ordinate.
      # @param y1 [Numeric] Lower left Y co-ordinate.
      # @param x2 [Numeric] Upper right X co-ordinate.
      # @param x2 [Numeric] Upper right Y co-ordinate.
      def draw_rectangle(x1:,y1:,x2:,y2:, border_color: nil, fill_color: nil,
                         border_width: nil, border_type: nil, abs: false)
        x1 = x_to_tk(x1, abs: abs)
        x2 = x_to_tk(x2, abs: abs)
        y1 = y_to_tk(y1, abs: abs)
        y2 = y_to_tk(y2, abs: abs)
        TkcRectangle.new(tk_canvas, x1, y1, x2, y2,
                         fill: color_to_tk(fill_color), outline: color_to_tk(border_color),
                         width: width_to_tk(border_width), dash: line_type_to_tk(border_type))
      end

      # Draw multiple markers as specified by co-ordinates.
      #
      # @param x [[Numeric]] Array of X co-ordinates.
      # @param y [[Numeric]] Array of Y co-ordinates.
      # @param marker_type [Symbol] A marker type from Rubyplot::MARKERS.
      # @param marker_color [Symbol] A color from Rubyplot::Color.
      # @param marker_size [Numeric] Size of the marker.
      def draw_markers(x:, y:, type:, fill_color:, border_color: nil, size:)
        (0..x.size - 1).each do |idx|
          draw_marker(x: x[idx], y: y[idx], type: type,
                      fill_color: fill_color, border_color: border_color, size: size[idx])
        end
      end

      # Draw a circle.n
      def draw_circle(x:, y:, radius:, border_width:, border_color:, border_type:,
                      fill_color:, fill_opacity:)
        x = x_to_tk(x)
        y = y_to_tk(y)
        radius = distance_to_tk(radius)
        TkcOval.new(tk_canvas, x - radius / 2, y - radius / 2, x + radius / 2, y + radius / 2,
                    fill: color_to_tk(fill_color), outline: color_to_tk(border_color),
                    width: width_to_tk(border_width), dash: line_type_to_tk(border_type),
                    stipple: opacity_to_tk_stipple(fill_opacity))
      end

      # Draw a polygon and fill it with color. Co-ordinates are specified in (x,y)
      # pairs in the coords Array.
      #
      # @param x [Array] Array containing X co-ordinates.
      # @param y [Array] Array containting Y co-ordinates.
      # @param border_width [Numeric] Widht of the border.
      def draw_polygon(x:, y:, border_width:, border_type:, border_color:, fill_color:,
                       fill_opacity:)
        TkcPolygon.new(tk_canvas, *points_to_tk(x, y),
                       fill: color_to_tk(fill_color), outline: color_to_tk(border_color),
                       width: width_to_tk(border_width), dash: line_type_to_tk(border_type),
                       stipple: opacity_to_tk_stipple(fill_opacity))
      end

      def draw_lines(x:, y:, width:, type:, color:, opacity:)
        TkcLine.new(tk_canvas, *points_to_tk(x, y),
                    fill: color_to_tk(color),
                    width: width_to_tk(width), dash: line_type_to_tk(type),
                    stipple: opacity_to_tk_stipple(opacity))
      end

      def draw_arrow(x1:, y1:, x2:, y2:, size:, style:)
        x1 = x_to_tk(x1)
        x2 = x_to_tk(x2)
        y1 = y_to_tk(y1)
        y2 = y_to_tk(y3)
        TkcLine.new(tk_canvas, x1, y1, x2, y2,
                    fill: color_to_tk(color), arrow: 'last',
                    arrowshape: arrow_to_tk(size, style))
      end

      def init_output_device file_name, device: :file
        raise NotImplementedError if device == :file
        tk_canvas.delete('all')
        @axes_map = {}
      end

      def stop_output_device
        draw_axes
      end

      def draw_x_axis(minor_ticks:, origin:, major_ticks:, minor_ticks_count:, major_ticks_count:)
        if @axes_map[active_axes.object_id].nil?
          @axes_map[@active_axes.object_id]={
            axes: @active_axes,
            x_origin: origin,
            minor_ticks: minor_ticks,
            major_ticks: major_ticks,
            minor_ticks_count: minor_ticks_count,
            major_ticks_count: major_ticks_count
          }
        else
          @axes_map[@active_axes.object_id].merge!(
            x_origin: origin,
            minor_ticks: minor_ticks,
            major_ticks: major_ticks,
            minor_ticks_count: minor_ticks_count,
            major_ticks_count: major_ticks_count
          )
        end
      end

      def draw_y_axis(minor_ticks:, origin:, major_ticks:, minor_ticks_count:, major_ticks_count:)
        if @axes_map[@active_axes.object_id].nil?
          @axes_map[@active_axes.object_id]={
            axes: @active_axes,
            y_origin: origin,
            minor_ticks: minor_ticks,
            major_ticks: major_ticks,
            minor_ticks_count: minor_ticks_count,
            major_ticks_count: major_ticks_count
          }
        else
          @axes_map[@active_axes.object_id].merge!(
            y_origin: origin,
            minor_ticks: minor_ticks,
            major_ticks: major_ticks,
            minor_ticks_count: minor_ticks_count,
            major_ticks_count: major_ticks_count
          )
        end
      end

      def draw_axes
        @axes_map.each_value do |v|
          axes = v[:axes]
          @active_axes = axes
          TkcLine.new(tk_canvas,
                      x_to_tk(axes.x_range[1]), y_to_tk(v[:y_origin]),
                      x_to_tk(v[:x_origin]), y_to_tk(v[:y_origin]),
                      x_to_tk(v[:x_origin]), y_to_tk(axes.y_range[1]),
                      fill: 'black', width: 2)
          # Drawing ticks
          # X major ticks
          axes.x_axis.major_ticks.each do |x_major_tick|
            TkcLine.new(tk_canvas,
                      x_to_tk(x_major_tick.coord), y_to_tk(v[:y_origin]),
                      x_to_tk(x_major_tick.coord), y_to_tk(v[:y_origin]) + x_major_tick.tick_size * 10.0,
                      fill: 'black', width: 2)
            TkcText.new(tk_canvas,
                        x_to_tk(x_major_tick.coord), y_to_tk(v[:y_origin]) + 20.0,
                        text: x_major_tick.label, anchor: 'center',
                        font: 'TkCaptionFont', fill: 'black')
          end
          # X minor ticks
          axes.x_axis.minor_ticks.each do |x_minor_tick|
            TkcLine.new(tk_canvas,
                      x_to_tk(x_minor_tick.coord), y_to_tk(v[:y_origin]),
                      x_to_tk(x_minor_tick.coord), y_to_tk(v[:y_origin]) + x_minor_tick.tick_size * 10.0,
                      fill: 'black', width: 2)
          end
          # Y major ticks
          axes.y_axis.major_ticks.each do |y_major_tick|
            TkcLine.new(tk_canvas,
                      x_to_tk(v[:x_origin]) - y_major_tick.tick_size * 10.0, y_to_tk(y_major_tick.coord),
                      x_to_tk(v[:x_origin]), y_to_tk(y_major_tick.coord),
                      fill: 'black', width: 2)
            TkcText.new(tk_canvas,
                        x_to_tk(v[:x_origin]) - 15.0, y_to_tk(y_major_tick.coord),
                        text: y_major_tick.label, anchor: 'e',
                        font: 'TkCaptionFont', fill: 'black')
          end
          # Y minor ticks
          axes.y_axis.minor_ticks.each do |y_minor_tick|
            TkcLine.new(tk_canvas,
                      x_to_tk(v[:x_origin]) - y_minor_tick.tick_size * 10.0, y_to_tk(y_minor_tick.coord),
                      x_to_tk(v[:x_origin]), y_to_tk(y_minor_tick.coord),
                      fill: 'black', width: 2)
          end
        end
      end

      private

      def x_to_tk(x, abs: false)
        x_factor = tk_canvas.winfo_width.to_f / @canvas_width.to_f
        if abs
          (@canvas_width.to_f * x.to_f / @figure.max_x.to_f) * x_factor
        else
          raw_x = ((x.to_f - @active_axes.x_range[0].to_f) / (@active_axes.x_range[1].to_f - @active_axes.x_range[0].to_f)) * @canvas_width.to_f * x_factor
          add_margin_x(raw_x)
        end
      end

      def y_to_tk(y, abs: false)
        y_factor = tk_canvas.winfo_height.to_f / @canvas_height.to_f
        if abs
          (@canvas_height.to_f * (@figure.max_y.to_f - y.to_f) / @figure.max_y.to_f) * y_factor
        else
          raw_y = ((@active_axes.y_range[1].to_f - y.to_f) / (@active_axes.y_range[1].to_f - @active_axes.y_range[0].to_f)) * @canvas_height.to_f * y_factor
          add_margin_y(raw_y)
        end
      end

      def add_margin_x(x)
        x_factor = tk_canvas.winfo_width.to_f / @canvas_width.to_f
        x_shift = (@active_axes.abs_x + @active_axes.left_margin) * @canvas_width / @figure.max_x
        x_shift *= x_factor
        real_width = @active_axes.width - (@active_axes.left_margin + @active_axes.right_margin)
        margin_factor = real_width.to_f / @figure.max_x
        (x + x_shift) * margin_factor
      end

      def add_margin_y(y)
        y_factor = tk_canvas.winfo_height.to_f / @canvas_height.to_f
        y_shift = ((@active_axes.height * (@figure.nrows - 1)) - (@active_axes.abs_y - @figure.bottom_spacing) + @figure.top_spacing + @active_axes.top_margin) * @canvas_height / @figure.max_y
        y_shift *= y_factor
        real_height = @active_axes.height - (@active_axes.bottom_margin + @active_axes.top_margin)
        margin_factor = real_height.to_f / @figure.max_y
        (y + y_shift) * margin_factor
      end

      def distance_to_tk(d, abs: false)
        x_to_tk(d, abs: abs)
      end

      def width_to_tk(w)
        w
      end

      def size_to_tk(s)
        s * 10.0
      end

      def points_to_tk(x, y)
        (0..x.size - 1).map do |idx|
          [x_to_tk(x[idx]), y_to_tk(y[idx])]
        end.flatten
      end

      def color_to_tk(color)
        Rubyplot::Color::COLOR_INDEX[color]
      end

      TEXT_HALIGNMENT_MAP = {
        normal: 'w',
        left: 'w',
        center: 'ew',
        right: 'e'
      }.freeze

      TEXT_VALIGNMENT_MAP = {
        normal: 's',
        top: 'n',
        cap: 's',
        half: 'ns',
        base: 's',
        bottom: 's'
      }.freeze

      def text_align_to_tk(halign, valign)
        TEXT_VALIGNMENT_MAP[valign] + TEXT_HALIGNMENT_MAP[halign]
      end

      def font_to_tk(font, size, font_weight)
        if font == :times_roman &&
           size == 25.0 &&
           font_weight.nil?
          # Default values for axes
          # Let's use a better font
          return 'TkMenuFont'
        end
        if font == :times_roman &&
           size == 20.0 &&
           font_weight.nil?
          # Default values for caption
          # Let's use a better font
          return 'TkCaptionFont'
        end
        "#{font} #{size.to_i} #{font_weight}"
      end

      def rotation_to_tk(rotation)
        (rotation || 0.0) * -1.0
      end

      def line_type_to_tk(type)
        nil
      end

      def arrow_to_tk(size, style)
        nil
      end

      def opacity_to_tk_stipple(opacity)
        if opacity == 1.0
          return nil
        elsif opacity >= 0.75
          return 'gray75'
        elsif opacity >= 0.5
          return 'gray50'
        elsif opacity >= 0.25
          return 'gray25'
        else
          return 'gray12'
        end
      end

      MARKER_PROCS = {
        dot: ->(canvas, x, y, border_color, fill_color, size) {
        },
        circle: ->(canvas, x, y, border_color, fill_color, size) {
          TkcOval.new(canvas, x - size / 2, y - size / 2, x + size / 2, y + size / 2,
                      fill: fill_color, outline: border_color)
        },
        diamond: ->(canvas, x, y, border_color, fill_color, size) {
          TkcPolygon.new(canvas,
                         x - size / 2, y,
                         x, y - size / 2,
                         x + size / 2, y,
                         x, y + size / 2,
                         fill: fill_color, outline: border_color)
        }
      }

      def draw_marker(x:, y:, type:, fill_color:, border_color:, size:)
        x = x_to_tk(x)
        y = y_to_tk(y)
        size = size_to_tk(size)
        fill_color = color_to_tk(fill_color)
        if (res = type.to_s.match(/\Asolid_(.*)/))
          type = r.captures.first.to_sym
          border_color = fill_color
        else
          border_color = color_to_tk(border_color)
        end
        code = MARKER_PROCS[type] || MARKER_PROCS[:circle]
        code.call(tk_canvas, x, y, border_color, fill_color, size)
      end
    end
  end
end
