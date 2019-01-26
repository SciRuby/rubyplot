module Rubyplot
  module Backend
    class Base
      # Total height and width of the canvas in pixels.
      attr_accessor :canvas_height, :canvas_width

      attr_accessor :active_axes, :figure
    end # class Base
  end # module Backend
end # module Rubyplot
