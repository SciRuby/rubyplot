require 'rmagick'

module Rubyplot
  module Backend
    module ImageMagickWrapper
      def imread(path)
        Magick::Image.read(path).first
      end

      def imshow(img, device)
        case device
        when :window
          img.display
          nil # return nil so that image is not printed on iruby
        when :iruby
          img
        else
          img.display
        end
      end

      def imwrite(img, file_name)
        img.write(file_name)
      end
    end # module ImageMagickWrapper
  end # module Backend
end # module Rubyplot
