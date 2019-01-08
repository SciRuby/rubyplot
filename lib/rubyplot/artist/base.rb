module Rubyplot
  module Artist
    class Base
      # Absolute X co-ordinate of this Aritist on the canvas.
      attr_reader :abs_x
      # Absolute Y co-ordinate of this Aritist on the canvas.
      attr_reader :abs_y
      def initialize(abs_x, abs_y)
        @abs_x = abs_x
        @abs_y = abs_y
      end
    end # class Base
  end # module Artist
end # module Rubyplot
