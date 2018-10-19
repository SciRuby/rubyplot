require 'rubyplot/version'

require 'rubyplot/figure'
require 'rubyplot/subplot'
require 'rubyplot/axes'

require 'rubyplot/magick_wrapper'

module Rubyplot
  class << self
    def backend
      @backend || :magick
    end

    attr_writer :backend
  end
end

