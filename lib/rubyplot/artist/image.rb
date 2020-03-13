module Rubyplot
  module Artist
    class Image
      def initialize(path)
        @image = Rubyplot.backend.imread(path)
      end

      def imshow
        Rubyplot.backend.output_device = Rubyplot.iruby_inline ? :iruby : :window
        Rubyplot.backend.imshow(@image, Rubyplot.backend.output_device)
      end

      def imwrite(path)
        Rubyplot.backend.imwrite(@image, path)
      end
    end # class Image
  end # module Artist
end # module Rubyplot
