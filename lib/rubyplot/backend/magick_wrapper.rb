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

      # Multiplier needed to convert given unit into pixels. (Magick default).
      PIXEL_MULTIPLIERS = {
        inch: 96,
        cm: 39.7953,
        pixel: 1
      }.freeze

      MARKER_TYPES = {
        # Default type is circle
        nil: ->(draw, x, y, fill_color, border_color, size) {
          draw.stroke Rubyplot::Color::COLOR_INDEX[border_color]
          draw.fill Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.circle(x,y, x + size,y)
        },
        circle: ->(draw, x, y, fill_color, border_color, size) {
          draw.stroke Rubyplot::Color::COLOR_INDEX[border_color]
          draw.fill Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.circle(x,y, x + size,y)
        },
        plus: ->(draw, x, y, fill_color, border_color, size) {
          # Stroke width is set to 1
          draw.stroke Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.polyline(
            x,y, x + size,y,
            x,y, x - size,y,
            x,y, x,y + size,
            x,y, x,y - size
          )
        },
        dot: ->(draw, x, y, fill_color, border_color, size) {
          # Dot is a circle of size 5 pixels
          # size is kept 5 to make it visible, ideally it should be 1
          # which is the smallest displayable size
          draw.fill Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.circle(x,y, x + 5,y)
        },
        asterisk: ->(draw, x, y, fill_color, border_color, size) {
          # Looks like a five sided star
        },
        diagonal_cross: ->(draw, x, y, fill_color, border_color, size) {
          # Looks like X
        },
        solid_circle: ->(draw, x, y, fill_color, border_color, size) {
          draw.stroke Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.fill Rubyplot::Color::COLOR_INDEX[fill_color]
          draw.circle(x,y, x + size,y)
        }
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
        @canvas_width, @canvas_height = scale_figure(@canvas_width, @canvas_height)
        @draw = Magick::Draw.new
        @axes = Magick::Draw.new
        @text = Magick::Draw.new
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
        abs_x:,abs_y:,rotation: nil, stroke: 'transparent', abs: true)
        within_window(abs) do
          x = transform_x(x: abs_x, abs: abs)
          y = transform_y(y: abs_y, abs: abs)

          @text.fill = Rubyplot::Color::COLOR_INDEX[color]
          @text.font = font.to_s if font
          @text.pointsize = size
          @text.font_weight = font_weight
          # @text.gravity = GRAVITY_MEASURE[gravity] || Magick::ForgetGravity
          @text.stroke stroke
          @text.stroke_antialias false
          @text.text_antialias = false
          modify_draw(@text, x_shift: x.to_i, y_shift: y.to_i, rotation: rotation) do |draw|
            draw.text(0,0, text.gsub('%', '%%'))
          end
        end
      end

      def draw_markers(x:, y:, type: nil, fill_color: :default, border_color: :default, size: nil)
        y.each_with_index do |iy, idx_y|
          ix = transform_x(x: x[idx_y],abs: false)
          iy = transform_y(y: iy, abs: false)
          # in GR backend size is multiplied by
          # nominal size generated on the graphics device
          # so setting the nominal_factor
          nominal_factor = 15
          within_window do
            size[idx_y] *= nominal_factor
            MARKER_TYPES[type].call(@draw, ix, iy, fill_color, border_color, size[idx_y])
          end
        end
      end

      # Draw a rectangle.
      def draw_rectangle(x1:,y1:,x2:,y2:, border_color: :default,
        fill_color: nil, border_width: 1, border_type: nil, abs: false)
        within_window(abs) do
          x1 = transform_x(x: x1, abs: abs)
          x2 = transform_x(x: x2, abs: abs)
          y1 = transform_y(y: y1, abs: abs)
          y2 = transform_y(y: y2, abs: abs)

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
      end

      def draw_line(x1:,y1:,x2:,y2:,color: :default, stroke: 'transparent',
        stroke_opacity: 0.0, stroke_width: 2.0)
        within_window do
          x1 = transform_x x: x1
          x2 = transform_x x: x2
          y1 = transform_y y: y1
          y2 = transform_y y: y2

          @draw.stroke_opacity stroke_opacity
          @draw.stroke_width stroke_width
          @draw.fill Rubyplot::Color::COLOR_INDEX[color]
          @draw.line x1, y1, x2, y2
        end
      end

      def draw_circle(x:, y:, radius:, border_type: nil, border_width: 1.0, fill_color: nil,
        border_color: :default, fill_opacity: 0.0)
        within_window do
          x = transform_x x: x
          y = transform_y y: y

          @draw.stroke_width border_width
          @draw.stroke Rubyplot::Color::COLOR_INDEX[border_color]
          @draw.fill Rubyplot::Color::COLOR_INDEX[fill_color] if fill_color
          @draw.fill_opacity fill_opacity
          @draw.circle(x,y,x-radius,y)
        end
      end
      # rubocop:enable Metrics/ParameterLists

      # Draw a polygon.
      #
      # @param coords [Array[Array]] Array of Arrays where first element of each sub-array is
      #   the X co-ordinate and the second element is the Y co-ordinate.
      def draw_polygon(coords:, fill_opacity: 0.0, color: :default,
        stroke: 'transparent')
        within_window do
          coords.map! { |c| [transform_x(x: c[0]), transform_y(y: c[1])] }
          @draw.stroke stroke
          @draw.fill Rubyplot::Color::COLOR_INDEX[color]
          @draw.fill_opacity fill_opacity
          @draw.polygon *coords.flatten
        end
      end

      def write
        draw_axes
        @draw.draw(@base_image)
        @text.draw(@base_image)
        @base_image.write(@file_name)
      end

      # Refresh this backend and remove all previously set data.
      def flush
        @axes_map = {}
        @file_name = nil
      end

      def stop_output_device
        @canvas_width, @canvas_height = unscale_figure(@canvas_width, @canvas_height)
        flush
      end

      private

      # Function to convert figure size to pixels
      def scale_figure(width, height)
        return width * PIXEL_MULTIPLIERS[@figure.figsize_unit], height * PIXEL_MULTIPLIERS[@figure.figsize_unit]
      end

      # Function to convert figure size from pixels to original unit
      def unscale_figure(width, height)
        return width / PIXEL_MULTIPLIERS[@figure.figsize_unit], height / PIXEL_MULTIPLIERS[@figure.figsize_unit]
      end

      # Render a gradient and return an Image.
      def render_gradient(top_color, bottom_color, width, height, direct)
        width, height = scale_figure(width, height)
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
      def transform_x(x: , abs: false)
        if abs
          (@canvas_width.to_f * x.to_f / @figure.max_x.to_f)
        else
          ((x.to_f - @active_axes.x_range[0].to_f) / (@active_axes.x_range[1].to_f - @active_axes.x_range[0].to_f)) * @canvas_width.to_f
        end
      end

      # Transform Y co-ordinate
      def transform_y(y: , abs: false)
        if abs
          (@canvas_height.to_f * (@figure.max_y.to_f - y.to_f) / @figure.max_y.to_f)
        else
          ((@active_axes.y_range[1].to_f - y.to_f) / (@active_axes.y_range[1].to_f - @active_axes.y_range[0].to_f)) * @canvas_height.to_f
        end
      end

      # Transform quantity that depends on X and Y.
      def transform_avg q
        @canvas_height * q
      end

      def draw_axes
        @axes_map.each_value do |v|
          axes = v[:axes]
          @active_axes = axes
          within_window do
            # Plot the X and Y axes
            @axes.polyline(
              transform_x(x: v[:x_origin]),transform_y(y: v[:y_origin]), transform_x(x: axes.x_range[1]),transform_y(y: v[:y_origin]),
              transform_x(x: v[:x_origin]),transform_y(y: v[:y_origin]), transform_x(x: v[:x_origin]),transform_y(y: axes.y_range[1])
            )
          end
        end
        @axes.draw(@base_image)
      end

      def modify_draw(draw, x_shift: nil, y_shift: nil, scale_x: nil, scale_y: nil, rotation: nil, &block)
        draw = [draw] unless draw.respond_to? :each # Making draw iterable if not iterable
        draw.each do |d|
          d.translate(x_shift, y_shift) if x_shift && y_shift
          d.rotate(rotation) if rotation
          d.scale(scale_x, scale_y) if scale_x && scale_y
        end

        draw.each do |d|
          yield(d)
        end

        draw.each do |d|
          d.scale(1 / scale_x, 1 / scale_y) if scale_x && scale_y
          d.rotate(90.0) if rotation
          d.translate(-1 * x_shift, -1 * y_shift) if x_shift && y_shift
        end
        draw = draw[0] unless draw.respond_to? :each
      end

      def within_window(abs=false, &block)
        if abs
          # Coordinates are given in rubyplot cordinates
          # Transform function handles deciding the position
          # in the figure
          yield
        else
          # Coordinates are not in rubyplot coordinates
          # Shifting to adjust incorporate the margin of the figure and axes
          # border! method can be used for figure margin but that will disturb rubyplot coordinates
          # i.e. rubyplot coordinates include the border spacing
          x_shift = (@active_axes.abs_x + @active_axes.left_margin) * @canvas_width / @figure.max_x # in pixels
          y_shift = (@active_axes.abs_y - @figure.bottom_spacing + @figure.top_spacing + @active_axes.top_margin) * @canvas_height / @figure.max_y # in pixels
          @draw.translate(x_shift, y_shift)
          @text.translate(x_shift, y_shift)
          @axes.translate(x_shift, y_shift)

          plottable_width = @active_axes.width - (@active_axes.left_margin + @active_axes.right_margin)
          plottable_height = @active_axes.height - (@active_axes.bottom_margin + @active_axes.top_margin)
          # Scaling
          @draw.scale(plottable_width / @figure.max_x, plottable_height / @figure.max_y)
          @text.scale(plottable_width / @figure.max_x, plottable_height / @figure.max_y)
          @axes.scale(plottable_width / @figure.max_x, plottable_height / @figure.max_y)

          # Calling the block
          yield

          # Rescaling
          @draw.scale(@figure.max_x / plottable_width, @figure.max_y / plottable_height)
          @text.scale(@figure.max_x / plottable_width, @figure.max_y / plottable_height)
          @axes.scale(@figure.max_x / plottable_width, @figure.max_y / plottable_height)

          # Reshifting to the original coordinates
          @draw.translate(-1 * x_shift, -1 * y_shift)
          @text.translate(-1 * x_shift, -1 * y_shift)
          @axes.translate(-1 * x_shift, -1 * y_shift)
        end
      end
    end # class MagickWrapper
  end # module Backend
end # module Rubyplot
