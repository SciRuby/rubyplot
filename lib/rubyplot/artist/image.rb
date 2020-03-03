module Rubyplot
  module Artist
    class Image < Artist::Base
      def initialize
      end

      def imread(path, idx=nil)
        Rubyplot.backend.init_image(device: Rubyplot.backend.output_device)
        Rubyplot.backend.imread(path, idx = idx)
      end

      def imshow(idx=0)
        Rubyplot.backend.output_device = Rubyplot.iruby_inline ? :iruby : :window
        Rubyplot.backend.init_image(device: Rubyplot.backend.output_device)
        Rubyplot.backend.imshow(idx = idx)
      end

      def imwrite(path,idx=0)
        Rubyplot.backend.init_image(device: :file)
        Rubyplot.backend.imwrite(path,idx = idx)
      end

      def imclear
        Rubyplot.backend.imclear
      end
    end # class Image
  end # module Artist
end # module Rubyplot
