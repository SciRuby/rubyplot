module Rubyplot
  module Artist
    class Image

      attr_accessor :rows, :columns, :pixel_array

      def initialize(columns,rows)
        @rows = rows
        @columns = columns
        @pixel_array = []
        @image = Rubyplot.backend.init_image(columns,rows)
      end

      def imread(path)
        @image = Rubyplot.backend.imread(path)
        @rows = @image.rows
        @columns = @image.columns
      end

      def imshow
        Rubyplot.backend.output_device = Rubyplot.iruby_inline ? :iruby : :window
        Rubyplot.backend.imshow(@image, Rubyplot.backend.output_device)
      end

      def imwrite(path)
        Rubyplot.backend.imwrite(@image, path)
      end

      def export_pixels(x, y, columns, rows, map)
        @pixel_array = []
        map.size.times do
          @pixel_array.push([])
        end
        flat_pix_array = Rubyplot.backend.export_pixels(@image, x, y, columns, rows, map)
        map.size.times do |channel|
          rows.times do |row|
            @pixel_array[channel].push(flat_pix_array[(channel*rows*columns)+(columns*row),columns])
          end
        end
        @pixel_array.flatten!(1) if map.size==1
        @pixel_array
      end

      def import_pixels(x, y, columns, rows, map, pixels)
        Rubyplot.backend.import_pixels(@image, x, y, columns, rows, map, pixels.to_a.flatten)
      end
    end # class Image
  end # module Artist
end # module Rubyplot
