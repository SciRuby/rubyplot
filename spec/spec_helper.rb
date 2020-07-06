require 'fileutils'
require 'pry'
require 'rubyplot'
require 'rspec'
require 'rmagick'

SPEC_ROOT = File.dirname(__FILE__) + "/"
TEMP_DIR = SPEC_ROOT + "temp/"
FIXTURES_DIR = SPEC_ROOT + "fixtures/"
display_img = nil

backend = ENV['RUBYPLOT_BACKEND']

if backend == "GR"
  ENV['GRDIR'] = "/usr/local/gr"
  ENV['GKS_FONTPATH'] = "/usr/local/gr"
  Rubyplot.set_backend :gr
elsif backend == "MAGICK"
  Rubyplot.set_backend :magick
end


RSpec::Matchers.define :eq_image do |expected_image, delta|
  compared_delta = 0
  match do |actual_image|
    compared_delta = compare_with_reference(actual_image, expected_image)
    compared_delta < delta
  end

  failure_message do |actual_image|
    "expected that delta be < #{delta} not #{compared_delta}
     comparison between:
     #{actual_image} | #{expected_image}\n"
  end
end

def compare_with_reference(test_image, reference_image)
  image1 = Magick::Image.read(test_image).first
  image2 = Magick::Image.read(reference_image).first
  diff = 0
  pixel_array_1 = image1.export_pixels
  pixel_array_2 = image2.export_pixels
  pixel_array_1.size.times do |i|
    diff += ( (pixel_array_1[i] - pixel_array_2[i]).abs / 3 )**2
  end

  Math.sqrt(diff / pixel_array_1.size)
end

RSpec.configure do |config|
  config.before(:suite) do
    FileUtils.mkdir_p TEMP_DIR
    FileUtils.mkdir_p FIXTURES_DIR
    $stdout.puts 'Do you want to display the image? [y/n]'
    display_img = $stdin.gets.chomp.strip[0].downcase
    while display_img != "y" && display_img != "n"
      $stdout.puts 'Please enter y or n'
      display_img = $stdin.gets.chomp.strip[0].downcase
    end
    if display_img == "y"
      display_img = true
    else
      display_img = false
    end
  end

  config.after(:example) do |example|
    @figure.show if display_img
    if @figure.is_a?(Rubyplot::Artist::Figure)
      plot_name = example.description.split.join("_") + ".png"
      base_image = TEMP_DIR + plot_name
      other_image = FIXTURES_DIR + plot_name
      @figure.write(other_image)
      @figure.write(base_image)

      expect(base_image).to eq_image(other_image, 100)
    end
  end

  config.after(:suite) do |example|
    # FileUtils.rm_rf SPEC_ROOT + TEMP_DIR
    # FileUtils.rm_rf SPEC_ROOT + FIXTURES_DIR
  end
end
