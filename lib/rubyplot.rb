require 'bigdecimal'

unless ENV["RUBYPLOT_BACKEND"]
  ENV["RUBYPLOT_BACKEND"] = "GR"
end

require 'rubyplot/color'
require 'rubyplot/utils'
require 'rubyplot/version'
require 'rubyplot/themes'
require 'rubyplot/artist'
require 'rubyplot/backend'
require 'rubyplot/figure'
require 'rubyplot/subplot'
require 'rubyplot/spi'
require 'rubyplot/image'

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
  ].freeze
  
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
  ].freeze

  TEXT_FONTS = [
    :times_roman,
    :times_italic,
    :times_bold,
    :times_bolditalic,
    :helvetica,
    :helvetica_oblique,
    :helvetica_bold,
    :helvetica_boldoblique,
    :courier,
    :courier_oblique,
    :courier_bold,
    :courier_boldoblique,
    :symbol,
    :bookman_light,
    :bookman_lightitalic,
    :bookman_demi,
    :bookman_demiitalic,
    :newcenturyschlbk_roman,
    :newcenturyschlbk_italic,
    :newcenturyschlbk_bold,
    :newcenturyschlbk_bolditalic,
    :avantgarde_book,
    :avantgarde_bookoblique,
    :avantgarde_demi,
    :avantgarde_demioblique,
    :palatino_roman,
    :palatino_italic,
    :palatino_bold,
    :palatino_bolditalic,
    :zapfchancery_mediumitalic,
    :zapfdingbats
  ].freeze

  TEXT_PRECISION = [
    :high,
    :med,
    :low
  ].freeze

  TEXT_DIRECTION = [
    :left_right,
    :right_left,
    :down_up,
    :up_down
  ].freeze

  FILL_STYLES = [
    :hollow,
    :solid,
    :pattern,
    :hatch
  ].freeze

  ARROW_STYLES = [
    :simple_single_ended,
    :simple_single_ended_acute,
    :hollow_single_ended,
    :filled_singled_ended,
    :triangle_single_ended,
    :filled_triangle_single_ended,
    :kite_single_ended,
    :filled_kite_single_ended,
    :simple_double_ended,
    :simple_double_ended_acute,
    :hollow_double_ended,
    :filled_double_ended,
    :triangle_double_ended,
    :filled_triangle_double_ended,
    :kite_double_ended,
    :filled_kite_double_ended,
    :double_line_single_ended,
    :double_line_double_ended
  ].freeze

  class << self

    attr_accessor :iruby_inline

    def backend
      @backend
    end

    def inline
      @iruby_inline = true
    end

    def stop_inline
      @iruby_inline = false
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

