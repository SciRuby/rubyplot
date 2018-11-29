require 'fileutils'
require 'rubyplot'

SPEC_ROOT = File.dirname(__FILE__) + "/"

class RubyplotSpec
  # methods for generating plots for testing
  # FIXME: figure out a better way of testing plots. This is too jugaadu.
  module Generators
    module Scatter
      class << self
        def random_scatter
          fig = Rubyplot::Figure.new
          axes = fig.add_subplot 0, 0
          axes.scatter!(400) do |p|
            p.data [1, 2, 3, 4, 5], [11, 2, 33, 4, 65]
            p.label = "data1"
            p.color = :plum_purple
          end

          fig.write(SPEC_ROOT + 'fixtures/scatter/scatter.png')
        end
      end # class << self
    end # module Scatter
  end # module Generators
end # module RubyplotSpec

RSpec::Matchers.define :eq_image do |expected_image, delta|
  compared_delta = 0
  match do |actual_image|
    compared_delta = compare_with_reference? actual_image, expected_image
    compared_delta < delta
  end

  failure_message do |actual_image|
    "expected that delta be < #{delta} not #{compared_delta}
     comparison between:
     #{actual_image} | #{expected_image}\n"
  end
end

def compare_with_reference?(test_image, reference_image)
  compute_rms(test_image, reference_image)
end

# Computes the RMS value between two images
def compute_rms(test_image, reference_image)
  image1 = Magick::Image.read(SPEC_ROOT + test_image).first
  image2 = Magick::Image.read(SPEC_ROOT + reference_image).first
  diff = 0
  pixel_array_1 = image1.export_pixels
  pixel_array_2 = image2.export_pixels
  pixel_array_1.size.times do |i|
    diff += ((pixel_array_1[i] - pixel_array_2[i]).abs / 3)**2
  end

  Math.sqrt(diff / (512 * 512))
end

def generate_plots
  ["Scatter"].each do |s|
    m = Kernel.const_get("RubyplotSpec::Generators::#{s}")
    m.methods(false).each do |meth|
      m.send(meth)
    end
  end
end


#generate_plots
