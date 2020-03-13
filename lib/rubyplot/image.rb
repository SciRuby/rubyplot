module Rubyplot
  class Image
    def initialize
      @image = nil
    end

    def imread(path)
      @image = Rubyplot::Artist::Image.new(path)
    end

    def imshow
      @image.imshow
    end

    def imwrite(path)
      @image.imwrite(path)
    end

    def imclear
      @image = nil
    end
  end # class Image
end # module Ruyplot
