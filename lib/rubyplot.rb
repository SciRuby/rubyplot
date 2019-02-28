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
