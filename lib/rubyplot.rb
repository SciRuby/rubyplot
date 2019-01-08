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

require 'rubyplot/gr_wrapper'

module Rubyplot
  @@backend = Rubyplot::Backend::MagickWrapper.new
  def self.backend
    @@backend
  end
end
