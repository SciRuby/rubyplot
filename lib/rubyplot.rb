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
  @@backend = Rubyplot::Backend::MagickWrapper.new
  class << self
    def backend
      @@backend
    end

    def set_backend_magick
      @@backed = Rubyplot::Backend::MagickWrapper.new
    end
  end
end # module Rubyplot
