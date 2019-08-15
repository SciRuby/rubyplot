require 'rmagick'

module Rubyplot
  module Backend
    # Wrapper around an Image Magick backend. In case of ImageMagick, the upper
    #   left corner of the canvas is the (0,0) co-ordinate and the lower right corner
    #   is (max_width, max_height).
    #
    # Transformation are applied accordingly before actual plotting happens since Rubyplot
    #   Artists treat the co-ordinate system differently. The `transform_x` and `transform_y`
    #   functions are used for this purpose.
    class MagickWrapper < Base
      include ::Magick

      NOMINAL_FACTOR_MARKERS = 15
      NOMINAL_FACTOR_CIRCLE = 27.5

      GRAVITY_MEASURE = {
        nil => Magick::ForgetGravity,
        :center => Magick::CenterGravity,
        :west => Magick::WestGravity,
        :east => Magick::EastGravity,
        :north => Magick::NorthGravity
      }.freeze

      # Multiplier needed to convert given unit into pixels. (Magick default).
      PIXEL_MULTIPLIERS = {
        inch: 96,
        cm: 39.7953,
        pixel: 1
      }.freeze

      MARKER_TYPES = {
        # Default type is circle
        # Stroke width is set to 1
        default: ->(draw, x, y, fill_color, border_color, size) {
          draw.stroke Rubyplot::Color::COLOR_INDEX[border_color]
          draw.fill Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.circle(x,y, x + size,y)
        },
        circle: ->(draw, x, y, fill_color, border_color, size) {
          draw.stroke Rubyplot::Color::COLOR_INDEX[border_color]
          draw.fill Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.circle(x,y, x + size,y)
        },
        plus: ->(draw, x, y, fill_color, border_color, size) {
          # size is length of one line
          draw.stroke Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.line(x - size/2, y, x + size/2, y)
          draw.line(x, y - size/2, x, y + size/2)
        },
        dot: ->(draw, x, y, fill_color, border_color, size) {
          # Dot is a circle of size 5 pixels
          # size is kept 5 to make it visible, ideally it should be 1
          # which is the smallest displayable size
          draw.fill Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.circle(x,y, x + 5,y)
        },
        asterisk: ->(draw, x, y, fill_color, border_color, size) {
          # Looks like a five sided star
          raise NotImplementedError, 'This marker has not yet been implemented'
        },
        diagonal_cross: ->(draw, x, y, fill_color, border_color, size) {
          # size is length of one line
          draw.stroke Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.line(x - size/2, y + size/2, x + size/2, y - size/2)
          draw.line(x - size/2, y - size/2, x + size/2, y + size/2)
        },
        solid_circle: ->(draw, x, y, fill_color, border_color, size) {
          draw.stroke Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.fill Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.circle(x,y, x + size,y)
        },
        triangle_down: ->(draw, x, y, fill_color, border_color, size) {
          # height and base are equal to size
          # x,y is center of base and height
          draw.stroke Rubyplot::Color::COLOR_INDEX[border_color]
          draw.fill Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.polyline(
            x - size/2, y - size/2, x + size/2, y - size/2,
            x + size/2, y - size/2, x, y + size/2,
            x, y + size/2, x - size/2, y - size/2
          )
        },
        solid_triangle_down: ->(draw, x, y, fill_color, border_color, size) {
          # height and base are equal to size
          # x,y is center of base and height
          draw.stroke Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.fill Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.polyline(
            x - size/2, y - size/2, x + size/2, y - size/2,
            x + size/2, y - size/2, x, y + size/2,
            x, y + size/2, x - size/2, y - size/2
          )
        },
        triangle_up: ->(draw, x, y, fill_color, border_color, size) {
          # height and base are equal to size
          # x,y is center of base and height
          draw.stroke Rubyplot::Color::COLOR_INDEX[border_color]
          draw.fill Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.polyline(
            x - size/2, y + size/2, x + size/2, y + size/2,
            x + size/2, y + size/2, x, y - size/2,
            x, y - size/2, x - size/2, y + size/2
          )
        },
        solid_triangle_up: ->(draw, x, y, fill_color, border_color, size) {
          # height and base are equal to size
          # x,y is center of base and height
          draw.stroke Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.fill Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.polyline(
            x - size/2, y + size/2, x + size/2, y + size/2,
            x + size/2, y + size/2, x, y - size/2,
            x, y - size/2, x - size/2, y + size/2
          )
        },
        square: ->(draw, x, y, fill_color, border_color, size) {
          # size is equal to side of the square
          # x,y is center of base and height i.e. center of the square
          draw.stroke Rubyplot::Color::COLOR_INDEX[border_color]
          draw.fill Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.polyline(
            x - size/2, y + size/2, x + size/2, y + size/2,
            x + size/2, y + size/2, x + size/2, y - size/2,
            x + size/2, y - size/2, x - size/2, y - size/2,
            x - size/2, y - size/2, x - size/2, y + size/2
          )
        },
        solid_square: ->(draw, x, y, fill_color, border_color, size) {
          # size is equal to side of the square
          # x,y is center of base and height i.e. center of the square
          draw.stroke Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.fill Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.polyline(
            x - size/2, y + size/2, x + size/2, y + size/2,
            x + size/2, y + size/2, x + size/2, y - size/2,
            x + size/2, y - size/2, x - size/2, y - size/2,
            x - size/2, y - size/2, x - size/2, y + size/2
          )
        },
        bowtie: ->(draw, x, y, fill_color, border_color, size) {
          # height and width are equal to size
          # x,y is center of width and height
          draw.stroke Rubyplot::Color::COLOR_INDEX[border_color]
          draw.fill Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.polyline(
            x - size/2, y - size/2, x + size/2, y + size/2,
            x + size/2, y + size/2, x + size/2, y - size/2,
            x + size/2, y - size/2, x - size/2, y + size/2,
            x - size/2, y + size/2, x - size/2, y - size/2
          )
        },
        solid_bowtie: ->(draw, x, y, fill_color, border_color, size) {
          # height and width are equal to size
          # x,y is center of width and height
          draw.stroke Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.fill Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.polyline(
            x - size/2, y - size/2, x + size/2, y + size/2,
            x + size/2, y + size/2, x + size/2, y - size/2,
            x + size/2, y - size/2, x - size/2, y + size/2,
            x - size/2, y + size/2, x - size/2, y - size/2
          )
        },
        hglass: ->(draw, x, y, fill_color, border_color, size) {
          # height and width are equal to size
          # x,y is center of width and height
          draw.stroke Rubyplot::Color::COLOR_INDEX[border_color]
          draw.fill Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.polyline(
            x - size/2, y - size/2, x + size/2, y + size/2,
            x + size/2, y + size/2, x - size/2, y + size/2,
            x - size/2, y + size/2, x + size/2, y - size/2,
            x + size/2, y - size/2, x - size/2, y - size/2
          )
        },
        solid_hglass: ->(draw, x, y, fill_color, border_color, size) {
          # height and width are equal to size
          # x,y is center of width and height
          draw.stroke Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.fill Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.polyline(
            x - size/2, y - size/2, x + size/2, y + size/2,
            x + size/2, y + size/2, x - size/2, y + size/2,
            x - size/2, y + size/2, x + size/2, y - size/2,
            x + size/2, y - size/2, x - size/2, y - size/2
          )
        },
        diamond: ->(draw, x, y, fill_color, border_color, size) {
          # size is equal to side of the square
          # x,y is center of base and height i.e. center of the square
          draw.stroke Rubyplot::Color::COLOR_INDEX[border_color]
          draw.fill Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.polyline(
            x, y - size/2, x + size/2, y,
            x + size/2, y, x, y + size/2,
            x, y + size/2, x - size/2, y,
            x - size/2, y, x, y - size/2
          )
        },
        solid_diamond: ->(draw, x, y, fill_color, border_color, size) {
          # size is equal to side of the square
          # x,y is center of base and height i.e. center of the square
          draw.stroke Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.fill Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.polyline(
            x, y - size/2, x + size/2, y,
            x + size/2, y, x, y + size/2,
            x, y + size/2, x - size/2, y,
            x - size/2, y, x, y - size/2
          )
        },
        star: ->(draw, x, y, fill_color, border_color, size) {
          # 5 sided star
          raise NotImplementedError, 'This marker has not yet been implemented'
        },
        solid_star: ->(draw, x, y, fill_color, border_color, size) {
          # 5 sided solid star
          raise NotImplementedError, 'This marker has not yet been implemented'
        },
        tri_up_down: ->(draw, x, y, fill_color, border_color, size) {
          raise NotImplementedError, 'This marker has not yet been implemented'
        },
        solid_tri_right: ->(draw, x, y, fill_color, border_color, size) {
          # height and base are equal to size
          # x,y is center of base and height
          draw.stroke Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.fill Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.polyline(
            x + size/2, y + size/2, x + size/2, y - size/2,
            x + size/2, y - size/2, x - size/2, y,
            x - size/2, y, x + size/2, y + size/2
          )
        },
        solid_tri_left: ->(draw, x, y, fill_color, border_color, size) {
          # height and base are equal to size
          # x,y is center of base and height
          draw.stroke Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.fill Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.polyline(
            x - size/2, y - size/2, x - size/2, y + size/2,
            x - size/2, y + size/2, x + size/2, y,
            x + size/2, y, x - size/2, y - size/2
          )
        },
        hollow_plus: ->(draw, x, y, fill_color, border_color, size) {
          # height and width are equal to size
          # x,y is center of width and height
          draw.stroke Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.fill_opacity 0
          draw.polyline(
            x + size/4, y- size/2, x + size/4, y - size/4,
            x + size/4, y - size/4, x + size/2, y - size/4,
            x + size/2, y - size/4, x + size/2, y + size/4,
            x + size/2, y + size/4, x + size/4, y + size/4,
            x + size/4, y + size/4, x + size/4, y + size/2,
            x + size/4, y + size/2, x - size/4, y + size/2,
            x - size/4, y + size/2, x - size/4, y + size/4,
            x - size/4, y + size/4, x - size/2, y + size/4,
            x - size/2, y + size/4, x - size/2, y - size/4,
            x - size/2, y - size/4, x - size/4, y - size/4,
            x - size/4, y - size/4, x - size/4, y - size/2,
            x - size/4, y - size/2, x + size/4, y - size/2
          )
          draw.fill_opacity 1
        },
        solid_plus: ->(draw, x, y, fill_color, border_color, size) {
          # height and width are equal to size
          # x,y is center of width and height
          draw.stroke Rubyplot::Color::COLOR_INDEX[border_color]
          draw.fill Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.polyline(
            x + size/4, y - size/2, x + size/4, y - size/4,
            x + size/4, y - size/4, x + size/2, y - size/4,
            x + size/2, y - size/4, x + size/2, y + size/4,
            x + size/2, y + size/4, x + size/4, y + size/4,
            x + size/4, y + size/4, x + size/4, y + size/2,
            x + size/4, y + size/2, x - size/4, y + size/2,
            x - size/4, y + size/2, x - size/4, y + size/4,
            x - size/4, y + size/4, x - size/2, y + size/4,
            x - size/2, y + size/4, x - size/2, y - size/4,
            x - size/2, y - size/4, x - size/4, y - size/4,
            x - size/4, y - size/4, x - size/4, y - size/2,
            x - size/4, y - size/2, x + size/4, y - size/2
          )
        },
        pentagon: ->(draw, x, y, fill_color, border_color, size) {
          raise NotImplementedError, 'This marker has not yet been implemented'
        },
        hexagon: ->(draw, x, y, fill_color, border_color, size) {
          raise NotImplementedError, 'This marker has not yet been implemented'
        },
        heptagon: ->(draw, x, y, fill_color, border_color, size) {
          raise NotImplementedError, 'This marker has not yet been implemented'
        },
        octagon: ->(draw, x, y, fill_color, border_color, size) {
          raise NotImplementedError, 'This marker has not yet been implemented'
        },
        star_4: ->(draw, x, y, fill_color, border_color, size) {
          raise NotImplementedError, 'This marker has not yet been implemented'
        },
        star_5: ->(draw, x, y, fill_color, border_color, size) {
          raise NotImplementedError, 'This marker has not yet been implemented'
        },
        star_6: ->(draw, x, y, fill_color, border_color, size) {
          raise NotImplementedError, 'This marker has not yet been implemented'
        },
        star_7: ->(draw, x, y, fill_color, border_color, size) {
          raise NotImplementedError, 'This marker has not yet been implemented'
        },
        star_8: ->(draw, x, y, fill_color, border_color, size) {
          raise NotImplementedError, 'This marker has not yet been implemented'
        },
        vline: ->(draw, x, y, fill_color, border_color, size) {
          # size is length of line
          draw.stroke Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.line(x, y - size/2, x, y + size/2)
        },
        hline: ->(draw, x, y, fill_color, border_color, size) {
          # size is length of line
          draw.stroke Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.line(x - size/2, y, x + size/2, y)
        },
        omark: ->(draw, x, y, fill_color, border_color, size) {
          # Hollow Square with truncated corners with side of square as size
          # x, y is the center of the side
          draw.stroke Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.fill_opacity 0
          draw.polyline(
            x - 3*size/8, y - size/2, x + 3*size/8, y - size/2,
            x + 3*size/8, y - size/2, x + size/2, y - 3*size/8,
            x + size/2, y - 3*size/8, x + size/2, y + 3*size/8,
            x + size/2, y + 3*size/8, x + 3*size/8, y + size/2,
            x + 3*size/8, y + size/2, x - 3*size/8, y + size/2,
            x - 3*size/8, y + size/2, x - size/2, y + 3*size/8,
            x - size/2, y + 3*size/8, x - size/2, y - 3*size/8,
            x - size/2, y - 3*size/8, x - 3*size/8, y - size/2
          )
          draw.fill_opacity 1
        }
      }.freeze

      LINE_TYPES = {
        # Default type is solid
        default: ->(draw, x1, y1, x2, y2, width, color, opacity) {
          draw.fill_opacity opacity
          draw.stroke_width width
          draw.fill Rubyplot::Color::COLOR_INDEX[color]
          draw.line x1, y1, x2, y2
        },
        solid: ->(draw, x1, y1, x2, y2, width, color, opacity) {
          draw.fill_opacity opacity
          draw.stroke_width width
          draw.fill Rubyplot::Color::COLOR_INDEX[color]
          draw.line x1, y1, x2, y2
        },
        dashed: ->(draw, x1, y1, x2, y2, width, color, opacity) {
          raise NotImplementedError, 'This line has not yet been implemented'
        },
        dotted: ->(draw, x1, y1, x2, y2, width, color, opacity) {
          raise NotImplementedError, 'This line has not yet been implemented'
        },
        dashed_dotted: ->(draw, x1, y1, x2, y2, width, color, opacity) {
          raise NotImplementedError, 'This line has not yet been implemented'
        },
        dash_2_dot: ->(draw, x1, y1, x2, y2, width, color, opacity) {
          raise NotImplementedError, 'This line has not yet been implemented'
        },
        dash_3_dot: ->(draw, x1, y1, x2, y2, width, color, opacity) {
          raise NotImplementedError, 'This line has not yet been implemented'
        },
        long_dash: ->(draw, x1, y1, x2, y2, width, color, opacity) {
          raise NotImplementedError, 'This line has not yet been implemented'
        },
        long_short_dash: ->(draw, x1, y1, x2, y2, width, color, opacity) {
          raise NotImplementedError, 'This line has not yet been implemented'
        },
        spaced_dash: ->(draw, x1, y1, x2, y2, width, color, opacity) {
          raise NotImplementedError, 'This line has not yet been implemented'
        },
        spaced_dot: ->(draw, x1, y1, x2, y2, width, color, opacity) {
          raise NotImplementedError, 'This line has not yet been implemented'
        },
        double_dot: ->(draw, x1, y1, x2, y2, width, color, opacity) {
          raise NotImplementedError, 'This line has not yet been implemented'
        },
        triple_dot: ->(draw, x1, y1, x2, y2, width, color, opacity) {
          raise NotImplementedError, 'This line has not yet been implemented'
        }
      }.freeze

      attr_reader :draw

      def initialize
        @axes_map = {}
        @base_image = nil
      end

      def draw_x_axis(origin:, minor_ticks:, major_ticks:, minor_ticks_count:, major_ticks_count:)
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

      def draw_y_axis(origin:, minor_ticks:, major_ticks:, minor_ticks_count:, major_ticks_count:)
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

      # Height in pixels of particular text.
      # @param text [String] Text to be measured.
      def text_height(text, font, font_size)
        @draw.pointsize = font_size
        @draw.font = font if font
        @draw.get_type_metrics(@base_image, text.to_s).height
      end

      # Width in pixels of particular text.
      # @param text [String] Text to be measured.
      def text_width(text, font, font_size)
        @draw.pointsize = font_size
        @draw.font = font if font
        @draw.get_type_metrics(@base_image, text.to_s).width
      end

      # Scale backend canvas to required proportion.
      def scale(scale)
        @draw.scale(scale, scale)
      end

      # Get the width and height of the text in pixels.
      def get_text_width_height(text)
        metrics = @draw.get_type_metrics(@base_image, text)
        [metrics.width, metrics.height]
      end

      # rubocop:disable Metrics/ParameterLists
      # Unused method argument - stroke
      def draw_text(text,color: :default,font: nil,size:,
        font_weight: Magick::NormalWeight, halign:, valign:,
        abs_x:,abs_y:,rotation: nil, stroke: 'transparent', abs: true)
        unless text.empty?
          within_window(abs) do
            x = transform_x(x: abs_x, abs: abs)
            y = transform_y(y: abs_y, abs: abs)

            @text.fill = Rubyplot::Color::COLOR_INDEX[color]
            @text.font = font.to_s if font
            @text.pointsize = size
            @text.font_weight = font_weight
            # @text.gravity = GRAVITY_MEASURE[gravity] || Magick::ForgetGravity
            @text.stroke stroke
            @text.stroke_antialias false
            @text.text_antialias = false
            modify_draw(@text, x_shift: x.to_i, y_shift: y.to_i, rotation: rotation) do |draw|
              draw.text(0,0, text.gsub('%', '%%'))
            end
          end
        end
      end

      def draw_markers(x:, y:, type: :default, fill_color: :default, border_color: :default, size: nil)
        y.each_with_index do |iy, idx_y|
          ix = transform_x(x: x[idx_y],abs: false)
          iy = transform_y(y: iy, abs: false)
          # in GR backend size is multiplied by
          # nominal size generated on the graphics device
          # so set the nominal_factor to 15
          within_window do
            size[idx_y] *= NOMINAL_FACTOR_MARKERS
            MARKER_TYPES[type].call(@draw, ix, iy, fill_color, border_color, size[idx_y])
          end
        end
      end

      # Draw a rectangle.
      def draw_rectangle(x1:,y1:,x2:,y2:, border_color: :default,
        fill_color: nil, border_width: 1, border_type: nil, abs: false)
        within_window(abs) do
          x1 = transform_x(x: x1, abs: abs)
          x2 = transform_x(x: x2, abs: abs)
          y1 = transform_y(y: y1, abs: abs)
          y2 = transform_y(y: y2, abs: abs)

          @draw.stroke Rubyplot::Color::COLOR_INDEX[border_color]
          @draw.fill Rubyplot::Color::COLOR_INDEX[fill_color] if fill_color
          @draw.stroke_width border_width.to_f
          # if fill_color is not given, the rectangle fill colour is transparent
          # i.e. only edges are visible
          @draw.fill_opacity 0 unless fill_color
          @draw.rectangle x1, y1, x2, y2
          @draw.fill_opacity 1 unless fill_color
        end
      end

      def draw_lines(x:, y:, width: 2.0, type: :default, color: :default, opacity: 1.0)
        within_window do
          y.each_with_index do |_, idx_y|
            if idx_y < (y.length - 1)
              x1 = transform_x(x: x[idx_y], abs: false)
              y1 = transform_y(y: y[idx_y], abs: false)
              x2 = transform_x(x: x[idx_y + 1], abs: false)
              y2 = transform_y(y: y[idx_y + 1], abs: false)
              LINE_TYPES[type].call(@draw, x1, y1, x2, y2, width, color, opacity)
            end
          end
        end
      end

      def draw_line(x1:,y1:,x2:,y2:, width:, type:, color:, opacity:)
        draw_lines(x: [x1, x2], y: [y1, y2], width: width, type: type, color: color, opacity: opacity)
      end

      def draw_circle(x:, y:, radius:, border_type: nil, border_width: 1.0, fill_color: nil,
        border_color: :default, fill_opacity: 0.0)
        within_window do
          x = transform_x x: x
          y = transform_y y: y

          @draw.stroke_width border_width
          @draw.stroke Rubyplot::Color::COLOR_INDEX[border_color]
          @draw.fill Rubyplot::Color::COLOR_INDEX[fill_color] if fill_color
          @draw.fill_opacity fill_opacity
          @draw.circle(x,y,x - (radius * NOMINAL_FACTOR_CIRCLE),y)
        end
      end
      # rubocop:enable Metrics/ParameterLists

      # Draw a polygon.
      #
      # @param coords (Array[Array]) Array of Arrays where first element of each sub-array is
      #   the X co-ordinate and the second element is the Y co-ordinate.
      def draw_polygon(x:, y:, border_width:, border_type:, border_color:, fill_color:,
        fill_opacity:)
        within_window do
          x = x.map! { |ix| transform_x(x: ix, abs: false) }
          y = y.map! { |iy| transform_y(y: iy, abs: false) }
          coords = x.zip(y)
          @draw.stroke_width border_width
          @draw.stroke Rubyplot::Color::COLOR_INDEX[border_color]
          @draw.fill Rubyplot::Color::COLOR_INDEX[fill_color]
          @draw.fill_opacity fill_opacity
          @draw.polygon *coords.flatten
          @draw.fill_opacity 1
        end
      end

      def draw_arrow(x1:, y1:, x2:, y2:, size:, style:)
        within_window do
          # TODO
        end
      end

      def write
        @draw.draw(@base_image)
        @text.draw(@base_image)
        draw_axes
      end

      def show
        @draw.draw(@base_image)
        @text.draw(@base_image)
        draw_axes
      end

      # Refresh this backend and remove all previously set data.
      def flush
        @axes_map = {}
        @file_name = nil
      end

      def init_output_device file_name = nil, device: :file
        @canvas_width, @canvas_height = scale_figure(@canvas_width, @canvas_height)
        @draw = Magick::Draw.new
        @axes = Magick::Draw.new
        @text = Magick::Draw.new

        top_color = Rubyplot::Color::COLOR_INDEX[@figure.theme_options[:background_colors][0]]
        bottom_color = Rubyplot::Color::COLOR_INDEX[@figure.theme_options[:background_colors][1]]
        direction = @figure.theme_options[:background_direction]

        @base_image = render_gradient top_color, bottom_color, @canvas_width, @canvas_height, direction
        # Initialize base_image again even if it exists as there may be a change in properties

        @output_device = device
        @file_name = file_name if @output_device == :file
      end

      def stop_output_device
        @canvas_width, @canvas_height = unscale_figure(@canvas_width, @canvas_height)
        case @output_device
        when :file
          @base_image.write(@file_name)
          flush
        when :window
          flush
          @base_image.display
          # return nil so that image is not printed on iruby
          nil
        when :iruby
          flush
          @base_image
        end
      end

      private

      # Function to convert figure size to pixels
      def scale_figure(width, height)
        case @figure.figsize_unit
        when :pixel
          raise RangeError, 'Figure with a dimension greater than 11500 pixels can not be plotted' if height>11500 || width>11500
        when :cm
          raise RangeError, 'Figure with a dimension greater than 290 cms can not be plotted' if height>290 || width>290
        when :inch
          raise RangeError, 'Figure with a dimension greater than 115 inches can not be plotted' if height>115 || width>115
        end

        [width * PIXEL_MULTIPLIERS[@figure.figsize_unit], height * PIXEL_MULTIPLIERS[@figure.figsize_unit]]
      end

      # Function to convert figure size from pixels to original unit
      def unscale_figure(width, height)
        [width / PIXEL_MULTIPLIERS[@figure.figsize_unit], height / PIXEL_MULTIPLIERS[@figure.figsize_unit]]
      end

      # Render a gradient and return an Image.
      def render_gradient(top_color, bottom_color, width, height, direct)
        gradient_fill = case direct
                        when :bottom_top
                          GradientFill.new(0, 0, 100, 0, bottom_color, top_color)
                        when :left_right
                          GradientFill.new(0, 0, 0, 100, top_color, bottom_color)
                        when :right_left
                          GradientFill.new(0, 0, 0, 100, bottom_color, top_color)
                        when :topleft_bottomright
                          GradientFill.new(0, 100, 100, 0, top_color, bottom_color)
                        when :topright_bottomleft
                          GradientFill.new(0, 0, 100, 100, bottom_color, top_color)
                        else
                          GradientFill.new(0, 0, 100, 0, top_color, bottom_color)
                        end
        Magick::Image.new(width, height, gradient_fill)
      end

      # Transform X co-ordinate.
      def transform_x(x: , abs: false)
        if abs
          (@canvas_width.to_f * x.to_f / @figure.max_x.to_f)
        else
          ((x.to_f - @active_axes.x_range[0].to_f) / (@active_axes.x_range[1].to_f - @active_axes.x_range[0].to_f)) * @canvas_width.to_f
        end
      end

      # Transform Y co-ordinate
      def transform_y(y: , abs: false)
        if abs
          (@canvas_height.to_f * (@figure.max_y.to_f - y.to_f) / @figure.max_y.to_f)
        else
          ((@active_axes.y_range[1].to_f - y.to_f) / (@active_axes.y_range[1].to_f - @active_axes.y_range[0].to_f)) * @canvas_height.to_f
        end
      end

      # Transform quantity that depends on X and Y.
      def transform_avg q
        @canvas_height * q
      end

      def draw_axes
        @axes_map.each_value do |v|
          axes = v[:axes]
          @active_axes = axes
          within_window do
            @axes.stroke Rubyplot::Color::COLOR_INDEX[:black]
            @axes.stroke_width 5
            if axes.square_axes
              @axes.fill_opacity 0
              @axes.rectangle(transform_x(x: v[:x_origin]),transform_y(y: v[:y_origin]), transform_x(x: axes.x_range[1]),transform_y(y: axes.y_range[1]))
            else
              @axes.line(transform_x(x: v[:x_origin]),transform_y(y: v[:y_origin]), transform_x(x: axes.x_range[1]),transform_y(y: v[:y_origin]))
              @axes.line(transform_x(x: v[:x_origin]),transform_y(y: v[:y_origin]), transform_x(x: v[:x_origin]),transform_y(y: axes.y_range[1]))
            end
          end
        end
        @axes.draw(@base_image)
      end

      def modify_draw(draw, x_shift: nil, y_shift: nil, scale_x: nil, scale_y: nil, rotation: nil, &block)
        draw = [draw] unless draw.respond_to? :each # Making draw iterable if not iterable
        draw.each do |d|
          d.translate(x_shift, y_shift) if x_shift && y_shift
          d.rotate(rotation) if rotation
          d.scale(scale_x, scale_y) if scale_x && scale_y
        end

        draw.each do |d|
          yield(d)
        end

        draw.each do |d|
          d.scale(1 / scale_x, 1 / scale_y) if scale_x && scale_y
          d.rotate(90.0) if rotation
          d.translate(-1 * x_shift, -1 * y_shift) if x_shift && y_shift
        end
        draw = draw[0] unless draw.respond_to? :each
      end

      def within_window(abs=false, &block)
        if abs
          # Coordinates are given in rubyplot cordinates
          # Transform function handles deciding the position
          # in the figure
          yield
        else
          # Coordinates are not in rubyplot coordinates
          # Shifting to adjust incorporate the margin of the figure and axes
          # border! method can be used for figure margin but that will disturb rubyplot coordinates
          # i.e. rubyplot coordinates include the border spacing
          x_shift = (@active_axes.abs_x + @active_axes.left_margin) * @canvas_width / @figure.max_x # in pixels
          y_shift = ((@active_axes.height * (@figure.nrows - 1)) - (@active_axes.abs_y - @figure.bottom_spacing) + @figure.top_spacing + @active_axes.top_margin) * @canvas_height / @figure.max_y # in pixels
          @draw.translate(x_shift, y_shift)
          @text.translate(x_shift, y_shift)
          @axes.translate(x_shift, y_shift)

          plottable_width = @active_axes.width - (@active_axes.left_margin + @active_axes.right_margin)
          plottable_height = @active_axes.height - (@active_axes.bottom_margin + @active_axes.top_margin)
          # Scaling
          @draw.scale(plottable_width / @figure.max_x, plottable_height / @figure.max_y)
          @text.scale(plottable_width / @figure.max_x, plottable_height / @figure.max_y)
          @axes.scale(plottable_width / @figure.max_x, plottable_height / @figure.max_y)

          # Calling the block
          yield

          # Rescaling
          @draw.scale(@figure.max_x / plottable_width, @figure.max_y / plottable_height)
          @text.scale(@figure.max_x / plottable_width, @figure.max_y / plottable_height)
          @axes.scale(@figure.max_x / plottable_width, @figure.max_y / plottable_height)

          # Reshifting to the original coordinates
          @draw.translate(-1 * x_shift, -1 * y_shift)
          @text.translate(-1 * x_shift, -1 * y_shift)
          @axes.translate(-1 * x_shift, -1 * y_shift)
        end
      end
    end # class MagickWrapper
  end # module Backend
end # module Rubyplot
