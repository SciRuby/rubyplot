module Rubyplot
  module Backend
    # Base class for backend. A new backend should implement all the below methods.
    class Base
      # Total height and width of the canvas in pixels.
      attr_accessor :canvas_height, :canvas_width

      attr_accessor :active_axes, :figure

      # Write text anywhere on the canvas. abs_x and abs_y should be specified in terms
      #   of Rubyplot Artist Co-ordinates.
      #
      # @param text [String] String of text to write.
      # @param abs_x [Numeric] X co-ordinate of the text in Rubyplot Artist Co-ordinates.
      # @param abs_y [Numeric] Y co-ordinate of the text in Rubyplot Aritst Co-ordinates.
      # @param font_color [Symbol] Color of the font from Rubyplot::Colors.
      # @param font [Symbol] Name of the font.
      # @param size [Numeric] Size of the font.
      # @param font_weight [Symbol] Measure of 'bigness' of the font.
      # @param rotation [Numeric] Angle between 0 and 360 degrees signifying rotation of text.
      # @param halign [Symbol] Horizontal alignment of the text from Artist::Text::HAlignment.
      # @param valign [Symbol] Vertical alignment of the text from Artist::Text::VAlignment
      def draw_text(text,font_color:,font: nil,size:,
        font_weight: nil, halign: nil, valign: nil,
        abs_x:, abs_y:,rotation: nil, stroke: nil)
        raise NotImplementedError, "not implemented for #{self}."
      end

      # Draw a rectangle with optional fill.
      #
      # @param x1 [Numeric] Lower left X co-ordinate.
      # @param y1 [Numeric] Lower left Y co-ordinate.
      # @param x2 [Numeric] Upper right X co-ordinate.
      # @param x2 [Numeric] Upper right Y co-ordinate.
      def draw_rectangle(x1:,y1:,x2:,y2:, border_color: nil, fill_color: nil,
        border_width: nil, border_type: nil)
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
