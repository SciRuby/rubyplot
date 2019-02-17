module Rubyplot
  module Artist
    class Text < Artist::Base
      attr_reader :color, :font, :font_size,
        :stroke, :weight, :gravity, :text, :backend

      # X and Y co-ordinates between (0,1) for writing text anywhere on the Axes or Figure.
      #  The relative co-ordinates are specified in relation to the object on which text
      #  needs to be written. For example different Axes within a Figure or the Figure itself.
      attr_reader :x, :y

      attr_reader :owner

      # Array containing valid horizontal alignment types.
      HAlignment = [
        :normal,
        :left,
        :center,
        :right
      ].freeze

      # Array containing valid vertical alignment types.
      VAlignment = [
        :normal,
        :top,
        :cap,
        :half,
        :base,
        :bottom
      ]

      # rubocop:disable Metrics/ParameterLists
      def initialize(text, owner, x:, y:,font: nil,
                     color: :black, font_size:,stroke: 'transparent',
                     internal_label: '', rotation: nil,
                     weight: nil, halign: :normal, valign: :normal)
        @x = x
        @y = y
        @text = text
        @owner = owner
        @font = font
        @color = color
        @font_size = font_size
        @stroke = stroke
        @internal_label = internal_label
        @rotation = rotation
        unless HAlignment.include? halign
          @halign = halign
        else
          raise "Invalid horizontal alignment #{halign}."
        end

        unless VAlignment.include? valign
          @valign = valign
        else
          raise "Invalid vertical alignment #{valign}."
        end
      end
      # rubocop:enable Metrics/ParameterLists

      # Height in pixels of this text
      def height
        Rubyplot.backend.text_height(@text, @font, @font_size)
      end

      # Width in pixels of this text
      def width
        Rubyplot.backend.text_width(@text, @font, @font_size)
      end

      def draw
        x, y = to_rubyplot_artist_coords @x, @y
        Rubyplot.backend.draw_text(
          @text,
          font_color: @color,
          font: @font,
          font_size: @font_size,
          stroke: @stroke,
          abs_x: @abs_x,
          abs_y: @abs_y,
          rotation: @rotation,
          halign: @halign,
          valign: @valign
        )
      end

      private

      # Transform user co-ordinates [0,1] to Rubyplot Artist Co-ordinates.
      def to_rubyplot_artist_coords x, y
        
      end
    end # class Text
  end # class Artist
end # module Rubyplot
