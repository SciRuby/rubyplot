require 'bigdecimal'

require 'rmagick'

require 'rubyplot/color'
require 'rubyplot/version'
require 'rubyplot/themes'
require 'rubyplot/artist'
require 'rubyplot/backend'
require 'rubyplot/figure'
require 'rubyplot/subplot'
require 'rubyplot/spi'

require 'grruby.so'
require 'rubyplot/magick_wrapper'
require 'rubyplot/gr_wrapper'

module Rubyplot
  def self.backend
    b = ENV['RUBYPLOT_BACKEND']
    return b.to_sym if b == "magick" || b == "gr"
    :magick
  end
end
