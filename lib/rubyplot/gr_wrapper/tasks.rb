module Rubyplot
  module GRWrapper
    module Tasks
      def hex_color_to_gr_color_index(rgbstring)
        rgb = rgbstring.match /#(..)(..)(..)/
        GR.inqcolorfromrgb((rgb[1].hex.to_f/255.0), (rgb[2].hex.to_f/255.0), (rgb[3].hex.to_f/255.0))
      end

      class BeginPrint
        attr_reader :file_name

        def initialize(file_name)
          @file_name = file_name
        end

        def call
          GR.beginprint(@file_name)
        end
      end

      class EndPrint
        def call
          GR.endprint
        end
      end

      class UpdateWorkspace
        def call
          GR.updatews
        end
      end

      class ClearWorkspace
        def call
          GR.clearws
        end
      end

      class Polymarker
        def initialize(x_coordinates, y_coordinates)
          @x_coordinates = x_coordinates
          @y_coordinates = y_coordinates
        end
        def call
          GR.polymarker(@x_coordinates, @y_coordinates)
        end
      end

      class Polyline
        def initialize(x_coordinates, y_coordinates)
          @x_coordinates = x_coordinates
          @y_coordinates = y_coordinates
        end
        def call
          GR.polyline(@x_coordinates, @y_coordinates)
        end
      end

      class FillRectangle
        def initialize(x_min, x_max, y_min, y_max)
          @x_min = x_min
          @x_max = x_max
          @y_min = y_min
          @y_max = y_max
        end

        def call
          GR.fillrect(@x_min, @x_max, @y_min, @y_max)
        end
      end

      class SetFillColorIndex
        def initialize(color_int)
          @color_int = color_int
        end

        def call
          GR.setfillcolorind(@color_int)
        end
      end

      class SetFillInteriorStyle
        def initialize(style)
          @style = style
        end

        def call
          GR.setfillintstyle(@style)
        end
      end

      class SetViewPort
        def initialize(x_min, x_max, y_min, y_max)
          @x_min = x_min
          @x_max = x_max
          @y_min = y_min
          @y_max = y_max
        end

        def call
          GR.setviewport(@x_min, @x_max, @y_min, @y_max)
        end
      end

      class SetWindow
        def initialize(x_min, x_max, y_min, y_max)
          @x_min = x_min
          @x_max = x_max
          @y_min = y_min
          @y_max = y_max
        end

        def call
          GR.setwindow(@x_min, @x_max, @y_min, @y_max)
        end
      end

      class SetLineWidth
        def initialize(width)
          @width = width
        end

        def call
          GR.setlinewidth(@width)
        end
      end

      class SetLineType
        def initialize(type)
          @type = type
        end

        def call
          GR.setlinetype(@type)
        end
      end

      class SetLineColorIndex
        def initialize(index)
          @index = index
        end

        def call
          GR.setlinecolorind(@index)
        end
      end

      class SetMarkerSize
        def initialize(size)
          @size = size
        end

        def call
          GR.setmarkersize(@size)
        end
      end

      class SetMarkerType
        def initialize(type)
          @type = type
        end

        def call
          GR.setmarkertype(@type)
        end
      end

      class SetMarkerColorIndex
        def initialize(index)
          @index = index
        end

        def call
          GR.setmarkercolorind(@index)
        end
      end

      class SetTextAlign
        def initialize(horizontal, vertical)
          @horizontal = horizontal
          @vertical = vertical
        end

        def call
          GR.settextalign(@horizontal, @vertical)
        end
      end

      class SetTextFontPrecision
        def initialize(font, precision)
          @font = font
          @precision = precision
        end

        def call
          GR.settextfontprec(@font, @precision)
        end
      end

      class SetCharHeight
        def initialize(height)
          @height = height
        end

        def call
          GR.setcharheight(@height)
        end
      end

      class AxesTitles
        def initialize(x_title, y_title, z_title)
          @x_title = x_title.to_s
          @y_title = y_title.to_s
          @z_title = z_title.to_s
        end

        def call
          GR.titles3d(@x_title, @y_title, @z_title)
        end
      end

      class Axes
        def initialize(x_major_tick, y_major_tick, x_origin, y_origin, major_x,
                       major_y, tick_size)
          @x_major_tick = x_major_tick
          @y_major_tick = y_major_tick
          @x_origin = x_origin
          @y_origin = y_origin
          @major_x = major_x
          @major_y = major_y
          @tick_size = tick_size
        end

        def call
          GR.axes(@x_major_tick, @y_major_tick, @x_origin, @y_origin, @major_x,
                  @major_y, @tick_size)
        end
      end

      class Grid
        def initialize(x_major_tick, y_major_tick, x_origin, y_origin, major_x,
                       major_y)
          @x_major_tick = x_major_tick
          @y_major_tick = y_major_tick
          @x_origin = x_origin
          @y_origin = y_origin
          @major_x = major_x
          @major_y = major_y
        end

        def call
          GR.grid(@x_major_tick, @y_major_tick, @x_origin, @y_origin, @major_x,
                  @major_y)
        end
      end

      class Text
        def initialize(x_loc, y_loc, text_string)
          @x_loc = x_loc
          @y_loc = y_loc
          @text_string = text_string
        end

        def call
          GR.text(@x_loc, @y_loc, @text_string)
        end
      end

      class DrawArc
        def initialize(x_min, x_max, y_min, y_max, starting_angle, ending_angle)
          @x_min = x_min
          @x_max = x_max
          @y_min = y_min
          @y_max = y_max
          @starting_angle = starting_angle
          @ending_angle = ending_angle
        end

        def call
          GR.drawarc(@x_min, @x_max, @y_min, @y_max, @starting_angle,
                     @ending_angle)
        end
      end

      class FillArc
        def initialize(x_min, x_max, y_min, y_max, starting_angle, ending_angle)
          @x_min = x_min
          @x_max = x_max
          @y_min = y_min
          @y_max = y_max
          @starting_angle = starting_angle
          @ending_angle = ending_angle
        end

        def call
          GR.fillarc(@x_min, @x_max, @y_min, @y_max, @starting_angle,
                     @ending_angle)
        end
      end

      GR_FONTS = {
        times_roman: 101,
        times_italic: 102,
        times_bold: 103,
        times_bold_italic: 104,
        helvetica: 105,
        helvetica_oblique: 106,
        helvetica_bold: 107,
        helvetica_bold_oblique: 108,
        courier: 109,
        courier_oblique: 110,
        courier_bold: 111,
        courier_bold_oblique: 112,
        symbol: 113,
        bookman_light: 114,
        bookman_light_italic: 115,
        bookman_demi: 116,
        bookman_demi_italic: 117,
        newcenturyschlbk_roman: 118,
        newcenturyschlbk_italic: 119,
        newcenturyschlbk_bold: 120,
        newcenturyschlbk_bold_italic: 121,
        avantgarde_book: 122,
        avantgarde_book_oblique: 123,
        avantgarde_demi: 124,
        avantgarde_demi_oblique: 125,
        palatino_roman: 126,
        palatino_italic: 127,
        palatino_bold: 128,
        palatino_bold_italic: 129,
        zapfchancery_medium_italic: 130,
        zapfdingbats: 131
      }.freeze

      GR_FONT_PRECISION = {
        text_precision_string: 0,
        text_precision_char: 1,
        text_precision_stroke: 2
      }.freeze

      # Marker types
      GR_MARKER_SHAPES = {
        dot: 1,
        plus: 2,
        asterisk: 3,
        circle: 4,
        diagonal_cross: 5,
        solid_circle: -1,
        triangle_up: -2,
        solid_tri_up: -3,
        triangle_down: -4,
        solid_tri_down: -5,
        square: -6,
        solid_square: -7,
        bowtie: -8,
        solid_bowtie: -9,
        hglass: -10,
        solid_hglass: -11,
        diamond: -12,
        solid_diamond: -13,
        star: -14,
        solid_star: -15,
        tri_up_down: -16,
        solid_tri_right: -17,
        solid_tri_left: -18,
        hollow_plus: -19,
        solid_plus: -20,
        pentagon: -21,
        hexagon: -22,
        heptagon: -23,
        octagon: -24,
        star_4: -25,
        star_5: -26,
        star_6: -27,
        star_7: -28,
        star_8: -29,
        vline: -30,
        hline: -31,
        omark: -32
      }.freeze

      GR_LINE_TYPES = {
        solid: 1,
        dashed: 2,
        dotted: 3,
        dashed_dotted: 4,
        dash_2_dot: -1,
        dash_3_dot: -2,
        long_dash: -3,
        long_short_dash: -4,
        spaced_dash: -5,
        spaced_dot: -6,
        double_dot: -7,
        triple_dot: -8
      }.freeze

      GR_FILL_INTERIOR_STYLES = {
        hollow: 0,
        solid: 1,
        pattern: 2,
        hatch: 3
      }.freeze
    end # module Tasks
  end # module GRWrapper
end # module Rubyplot
