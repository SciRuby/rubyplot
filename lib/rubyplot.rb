require 'bigdecimal'

require 'rubyplot/version'
require 'rubyplot/color'
require 'rubyplot/figure'
require 'rubyplot/subplot'
require 'rubyplot/axes'
require 'rubyplot/spi'

require 'grruby.so'
require 'rubyplot/magick_wrapper'
require 'rubyplot/gr_wrapper'

module Rubyplot
  class << self
    attr_accessor :backend
  end
end

Rubyplot.backend = :magick
