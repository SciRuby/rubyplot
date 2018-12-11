module Rubyplot  
  module Backend
    class MagickWrapper
      include ::Magick
      GRAVITY_MEASURE = {
        nil => Magick::ForgetGravity,
        :center => Magick::CenterGravity,
        :west => Magick::WestGravity,
        :east => Magick::EastGravity,
        :north => Magick::NorthGravity
      }

      attr_reader :draw
      
      def initialize
        @draw = Magick::Draw.new
      end

      # Returns the height of the capital letter 'X' for the current font and
      # size.
      #
      # Not scaled since it deals with dimensions that the regular scaling will
      # handle.
      def caps_height font, font_size
        @draw.pointsize = font_size
        @draw.font = font if font
        @draw.get_type_metrics(@base_image, 'X').height
      end

      # Returns the width of a string at this pointsize.
      #
      # Not scaled since it deals with dimensions that the regular
      # scaling will handle.
      # FIXME: duplicate with get_text_width_height
      def string_width font, font_size, text
        @draw.pointsize = font_size
        @draw.font = font if font
        @draw.get_type_metrics(@base_image, text.to_s).height
      end

      # Height in pixels of particular text.
      # @param text [String] Text to be measured.
      def text_height text, font, font_size
        @draw.pointsize = font_size
        @draw.font = font if font
        @draw.get_type_metrics(@base_image, text.to_s).height
      end

      # Width in pixels of particular text.
      # @param text [String] Text to be measured.
      def text_width text, font, font_size
        @draw.pointsize = font_size
        @draw.font = font if font
        @draw.get_type_metrics(@base_image, text.to_s).width
      end

      # Scale backend canvas to required proportion.
      def scale scale
        @draw.scale(scale, scale)
      end

      def set_base_image_gradient top_color, bottom_color, width, height, direct=:top_bottom
        @base_image = render_gradient top_color, bottom_color, width, height, direct
      end

      # Get the width and height of the text in pixels.
      def get_text_width_height text
        metrics = @draw.get_type_metrics(@base_image, text)
        [metrics.width, metrics.height]
      end

      def draw_text(text,font_color:,font: nil,pointsize:,stroke:,
                    font_weight: Magick::NormalWeight, gravity: nil,
                    x:,y:,rotation: nil)
        @draw.fill = font_color
        @draw.font = font if font
        @draw.pointsize = pointsize
        @draw.font_weight = font_weight
        @draw.gravity = GRAVITY_MEASURE[gravity] || Magick::ForgetGravity
        @draw.rotation = rotation if rotation
        @draw.annotate(@base_image, 0,0,x.to_i,y.to_i, text.gsub('%', '%%'))
        @draw.rotation = 90.0 if rotation
      end

      def draw_rectangle x1:,y1:,x2:,y2:,color: '#000000', stroke: 'transparent'
        @draw.stroke stroke
        @draw.fill color
        @draw.rectangle x1, y1, x2, y2
      end

      def draw_line(x1:,y1:,x2:,y2:,color: '#000000', stroke: 'transparent',
                    stroke_opacity: 0.0, stroke_width: 2.0)
        @draw.stroke_opacity stroke_opacity
        @draw.stroke_width stroke_width
        @draw.fill color
        @draw = @draw.line x1, y1, x2, y2
      end

      def draw_circle(x:,y:,radius:,stroke_opacity:,stroke_width:,color:)
        @draw.stroke_opacity stroke_opacity
        @draw.stroke_width stroke_width
        @draw.fill color
        @draw.circle(x,y,x-radius,y)
      end

      def write file_name
        @draw.draw(@base_image)
        @base_image.write(file_name)
      end

      private
      # Render a gradient and return an Image.
      def render_gradient top_color, bottom_color, width, height, direct
        gradient_fill = case direct
                        when :bottom_top
                          GradientFill.new(0, 0, 100, 0, bottom_color, top_color)
                        when :left_right
                          GradientFill.new(0, 0, 0, 100, top_color, bottom_color)
                        when :right_left
                          GradientFill.new(0, 0, 0, 100, bottom_color, top_color)
                        when :topleft_bottomright
                          GradientFill.new(0, 100, 100, 0, top_color, bottom_color)
                        when :topright_bottomleft
                          GradientFill.new(0, 0, 100, 100, bottom_color, top_color)
                        else
                          GradientFill.new(0, 0, 100, 0, top_color, bottom_color)
                        end
        Image.new(width, height, gradient_fill)
      end
    end # class MagickWrapper
  end # module Backend
end # module Rubyplot
