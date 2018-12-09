module Rubyplot
  module Artist
    class Base
      attr_reader :backend
      # Absolute X co-ordinate of this Aritist on the canvas.
      attr_reader :abs_x
      # Absolute Y co-ordinate of this Aritist on the canvas.
      attr_reader :abs_y
    end
  end
end
