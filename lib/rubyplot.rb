require 'bigdecimal'

require 'rmagick'

require 'rubyplot/color'
require 'rubyplot/utils'
require 'rubyplot/version'
require 'rubyplot/themes'
require 'rubyplot/artist'
require 'rubyplot/backend'
require 'rubyplot/figure'
require 'rubyplot/subplot'
require 'rubyplot/spi'

module Rubyplot
  LINE_TYPES = [
    :solid,
    :dashed,
    :dotted,
    :dashed_dotted,
    :dash_2_dot,
    :dash_3_dot,
    :long_dash,
    :long_short_dash,
    :spaced_dash,
    :spaced_dot,
    :double_dot,
    :triple_dot,
  ]
  
  MARKER_TYPES = [
    :dot,
    :plus,
    :asterisk,
    :circle,
    :diagonal_cross,
    :solid_circle,
    :triangle_up,
    :solid_triangle_up,
    :triangle_down,
    :solid_triangle_down,
    :square,
    :solid_square,
    :bowtie,
    :solid_bowtie,
    :hglass,
    :solid_hglass,
    :diamond,
    :solid_diamond,
    :star,
    :solid_star,
    :tri_up_down,
    :solid_tri_right,
    :solid_tri_left,
    :hollow_plus,
    :solid_plus,
    :pentagon,
    :hexagon,
    :heptagon,
    :octagon,
    :star_4,
    :star_5,
    :star_6,
    :star_7,
    :star_8,
    :vline,
    :hline,
    :omark
  ]
  # Min. co-ordinates of the lower left corner.
  MIN_X = 0
  MIN_Y = 0

  # Max. co-ordinates of the upper right corner.
  MAX_X = 100
  MAX_Y = 100
  class << self
    def backend
      @backend
    end

    def set_backend b
      case b
      when :magick
        @backend = Rubyplot::Backend::MagickWrapper.new
      when :gr
        @backend = Rubyplot::Backend::GRWrapper.new
      end
    end
  end
end # module Rubyplot
