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

require 'rubyplot/grwrapper'

module Rubyplot
  def self.backend
    b = ENV['RUBYPLOT_BACKEND']
    return b.to_sym if %w[magick ].include?(b)

    :magick
  end
end
