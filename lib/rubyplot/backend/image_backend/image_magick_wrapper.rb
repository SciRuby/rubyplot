require 'rmagick'

module Rubyplot
  module Backend
    module ImageMagickWrapper
      def init_image(columns,rows)
        Magick::Image.new(columns,rows)
      end

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

      def export_pixels(img, x, y, columns, rows, map)
        img.export_pixels(x, y, columns, rows, map)
      end

      def import_pixels(img, x, y, columns, rows, map, pixels)
        img.import_pixels(x, y, columns, rows, map, pixels)
      end
    end # module ImageMagickWrapper
  end # module Backend
end # module Rubyplot
