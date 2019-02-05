module Rubyplot
  module Backend
    # Base class for backend. A new backend should implement all the below methods.
    class Base
      # Total height and width of the canvas in pixels.
      attr_accessor :canvas_height, :canvas_width

      attr_accessor :active_axes, :figure

      def draw_text(text,font_color:,font: nil,font_size:,
        font_weight: nil, gravity: nil,
        x:,y:,rotation: nil, stroke: nil)
        raise NotImplementedError, "not implemeted for #{self}."
      end

      # Draw a rectangle with optional fill.
      #
      # @param x1 [Numeric] Lower left X co-ordinate.
      # @param y1 [Numeric] Lower left Y co-ordinate.
      # @param x2 [Numeric] Upper right X co-ordinate.
      # @param x2 [Numeric] Upper right Y co-ordinate.
      def draw_rectangle(x1:,y1:,x2:,y2:,border_color: nil,stroke: nil,
        fill_color: nil, stroke_width: nil)
        raise NotImplementedError, "not implemented for #{self}."
      end

      # Draw multiple markers as specified by co-ordinates.
      #
      # @param x [[Numeric]] Array of X co-ordinates.
      # @param y [[Numeric]] Array of Y co-ordinates.
      # @param marker_type [Symbol] A marker type from Rubyplot::MARKERS.
      # @param marker_color [Symbol] A color from Rubyplot::Color.
      # @param marker_size [Numeric] Size of the marker.
      def draw_markers(x:, y:, marker_type:, marker_color:, marker_size:)
        raise NotImplementedError, "not implemented for #{self}."
      end
    end # class Base
  end # module Backend
end # module Rubyplot
