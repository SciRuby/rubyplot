require 'rmagick'

module Rubyplot
  module Backend
    # Wrapper around an Image Magick backend. In case of ImageMagick, the upper
    #   left corner of the canvas is the (0,0) co-ordinate and the lower right corner
    #   is (max_width, max_height).
    # 
    # Transformation are applied accordingly before actual plotting happens since Rubyplot
    #   Artists treat the co-ordinate system differently. The `transform_x` and `transform_y`
    #   functions are used for this purpose.
    class MagickWrapper < Base
      include ::Magick
      GRAVITY_MEASURE = {
        nil => Magick::ForgetGravity,
        :center => Magick::CenterGravity,
        :west => Magick::WestGravity,
        :east => Magick::EastGravity,
        :north => Magick::NorthGravity
      }.freeze

      attr_reader :draw

      def initialize
        @axes_map = {}  
      end

      def draw_x_axis(minor_ticks:, origin:, major_ticks:, major_ticks_count:)
        if @axes_map[active_axes.object_id].nil?
          @axes_map[@active_axes.object_id]={
            axes: @active_axes,
            x_origin: origin
          }
        else
          @axes_map[@active_axes.object_id].merge!(x_origin: origin)
        end        
      end

      def draw_y_axis(minor_ticks:, origin:, major_ticks:, major_ticks_count:)
        if @axes_map[@active_axes.object_id].nil?
          @axes_map[@active_axes.object_id]={
          axes: @active_axes,
          y_origin: origin
          }
        else
          @axes_map[@active_axes.object_id].merge!(y_origin: origin)
        end
      end

      def init_output_device file_name, device: :file
        @draw = Magick::Draw.new
        @axes = Magick::Draw.new
        @file_name = file_name
      end

      # Height in pixels of particular text.
      # @param text [String] Text to be measured.
      def text_height(text, font, font_size)
        @draw.pointsize = font_size
        @draw.font = font if font
        @draw.get_type_metrics(@base_image, text.to_s).height
      end

      # Width in pixels of particular text.
      # @param text [String] Text to be measured.
      def text_width(text, font, font_size)
        @draw.pointsize = font_size
        @draw.font = font if font
        @draw.get_type_metrics(@base_image, text.to_s).width
      end

      # Scale backend canvas to required proportion.
      def scale(scale)
        @draw.scale(scale, scale)
      end

      def set_base_image_gradient(top_color, bottom_color, width, height, direct=:top_bottom)
        @base_image = render_gradient top_color, bottom_color, width, height, direct
      end

      # Get the width and height of the text in pixels.
      def get_text_width_height(text)
        metrics = @draw.get_type_metrics(@base_image, text)
        [metrics.width, metrics.height]
      end

      # rubocop:disable Metrics/ParameterLists
      # Unused method argument - stroke
      def draw_text(text,color: :default,font: nil,size:,
                    font_weight: Magick::NormalWeight, halign:, valign:,
                    abs_x:,abs_y:,rotation: nil, stroke: 'transparent')
        x = transform_x abs_x
        y = transform_y abs_y
        
        @draw.fill = Rubyplot::Color::COLOR_INDEX[color]
        @draw.font = font.to_s if font
        @draw.pointsize = size
        @draw.font_weight = font_weight
        #@draw.gravity = GRAVITY_MEASURE[gravity] || Magick::ForgetGravity
        @draw.stroke stroke
        @draw.stroke_antialias false
        @draw.text_antialias = false
        @draw.rotate rotation if rotation
        @draw.annotate(@base_image, 0,0,x.to_i,y.to_i, text.gsub('%', '%%'))
        @draw.rotate 90.0 if rotation
      end

      def draw_markers(x:, y:, type: nil, color: :default, size: nil)
        y.each_with_index do |iy, idx_y|
          ix = x[idx_y]

          Rubyplot::Artist::Circle.new(
            self, x: ix, y: iy, radius: size, border_opacity: 0.0,
            color: color, border_width: 1.0, abs: false 
          ).draw
        end
      end

      # Draw a rectangle.
      def draw_rectangle(x1:,y1:,x2:,y2:, border_color: :default, fill_color: nil,
                          border_width: 1, border_type: nil, abs: false)
        x1 = transform_x x1
        y1 = transform_y y1
        x2 = transform_x x2
        y2 = transform_y y2

        if fill_color # solid rectangle
          @draw.stroke Rubyplot::Color::COLOR_INDEX[border_color]
          @draw.fill Rubyplot::Color::COLOR_INDEX[fill_color]
          @draw.stroke_width border_width.to_f
          @draw.rectangle x1, y1, x2, y2
        else # just edges
          @draw.stroke_width border_width.to_f
          @draw.fill Rubyplot::Color::COLOR_INDEX[border_color]
          @draw.line x1, y1, x1 + (x2-x1), y1 # top line
          @draw.line x1 + (x2-x1), y1, x2, y2 # right line
          @draw.line x2, y2, x1, y1 + (y2-y1) # bottom line
          @draw.line x1, y1, x1, y1 + (y2-y1) # left line
        end
      end

      def draw_line(x1:,y1:,x2:,y2:,color: :default, stroke: 'transparent',
                    stroke_opacity: 0.0, stroke_width: 2.0)
        x1 = transform_x x1
        x2 = transform_x x2
        y1 = transform_y y1
        y2 = transform_y y2
        
        @draw.stroke_opacity stroke_opacity
        @draw.stroke_width stroke_width
        @draw.fill Rubyplot::Color::COLOR_INDEX[color]
        @draw.line x1, y1, x2, y2
      end

      def draw_circle(x:, y:, radius:, border_type: nil, border_width: 1.0, fill_color: nil,
        border_color: :default, fill_opacity: 0.0)
        x = transform_x x
        y = transform_y y

        @draw.stroke_width border_width
        @draw.stroke Rubyplot::Color::COLOR_INDEX[border_color]
        @draw.fill Rubyplot::Color::COLOR_INDEX[fill_color] if fill_color
        @draw.fill_opacity fill_opacity
        @draw.circle(x,y,x-radius[0],y) #TODO: make raduis single vaiable instead of an array 
      end
      # rubocop:enable Metrics/ParameterLists

      # Draw a polygon.
      #
      # @param coords [Array[Array]] Array of Arrays where first element of each sub-array is
      #   the X co-ordinate and the second element is the Y co-ordinate.
      def draw_polygon(coords:, fill_opacity: 0.0, color: :default,
                       stroke: 'transparent')
        coords.map! { |c| [transform_x(c[0]), transform_y(c[1])] }
        @draw.stroke stroke
        @draw.fill Rubyplot::Color::COLOR_INDEX[color]
        @draw.fill_opacity fill_opacity
        @draw.polygon *coords.flatten
      end

      def write
        draw_axes
        @draw.draw(@base_image)
        @base_image.write(@file_name)
      end

      # Refresh this backend and remove all previously set data.
      def flush
        @axes_map = {}
        @file_name = nil
      end

      def stop_output_device
        flush
      end

      private

      # Render a gradient and return an Image.
      def render_gradient(top_color, bottom_color, width, height, direct)
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
        Magick::Image.new(width, height, gradient_fill)
      end

      # Transform X co-ordinate.
      def transform_x x
        (@canvas_width * x) / @figure.max_x
      end

      def transform_y y
        (@canvas_height * (@figure.max_y - y)) / @figure.max_y
      end

      # Transform quantity that depends on X and Y.
      def transform_avg q
        @canvas_height * q
      end

      def draw_axes
        @axes_map.each_value do |v|
          axes = v[:axes]
          @active_axes = axes
          @axes.polyline(
            transform_x(v[:x_origin]),transform_y(v[:y_origin]), transform_x(axes.x_range[0]),transform_y(v[:y_origin]),
            transform_x(v[:x_origin]),transform_y(v[:y_origin]), transform_x(axes.x_range[1]),transform_y(v[:y_origin]),
            transform_x(v[:x_origin]),transform_y(v[:y_origin]), transform_x(v[:x_origin]),transform_y(axes.y_range[0]),
            transform_x(v[:x_origin]),transform_y(v[:y_origin]), transform_x(v[:x_origin]),transform_y(axes.y_range[1]))
        end
        @axes.draw(@base_image)
      end
    end # class MagickWrapper
  end # module Backend
end # module Rubyplot
