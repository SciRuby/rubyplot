module Rubyplot
  class Image

    attr_reader :rows, :columns

    def initialize(columns=0, rows=0)
      Rubyplot.set_backend :magick # Setting Magick backend as Image is not yet implemented for GR backend
      @rows = rows
      @columns = columns
      @image = Rubyplot::Artist::Image.new(columns, rows)
    end

    def imread(path)
      @image.imread(path)
      @rows = @image.rows
      @columns = @image.columns
    end

    def imshow
      @image.imshow
    end

    def imwrite(path)
      @image.imwrite(path)
    end

    def export_pixels(map='RGB', x=0, y=0, columns=@columns, rows=@rows)
      @image.export_pixels(x, y, columns, rows, map)
    end

    def import_pixels(pixels, map='RGB', x=0, y=0, columns=@columns, rows=@rows)
      @image.import_pixels(x, y, columns, rows, map, pixels)
    end

    def rows=(nrows)
      @image.rows = nrows
      @rows = nrows
    end

    def columns=(ncols)
      @image.columns = ncols
      @columns = ncols
    end

    def pixel_array
      @image.pixel_array
    end

    def imclear
      @image = nil
    end
  end # class Image
end # module Ruyplot
