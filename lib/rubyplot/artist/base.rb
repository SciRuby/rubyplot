module Rubyplot
  module Artist
    class Base
      # Artist backend. ImageMagick or whatever.
      attr_reader :backend
      # Absolute X co-ordinate of this Aritist on the canvas.
      attr_reader :abs_x
      # Absolute Y co-ordinate of this Aritist on the canvas.
      attr_reader :abs_y
      def initialize(backend, abs_x, abs_y)
        @backend = backend
        @abs_x = abs_x
        @abs_y = abs_y
      end
    end
    # class Base
  end
  # module Artist
end
# module Rubyplot
