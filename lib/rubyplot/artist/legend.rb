module Rubyplot
  class Artist
    class Legend
      attr_reader :legend_box_size, :font, :font_size, :font_color
      
      # legends - [String] Array of strings that has legend names.
      # colors - [String] Array of corresponding colors
      def initialize axes, artist, legends, colors
        @axes = axes
        @artist = artist
        @legends = legends
        @colors = colors
        @legend_box_size = 20.0 # size of the color box of the legend.
        @font_size = 20.0
        @font = @artist.font
        @font_color = @artist.font_color
        calculate_legend_size
        calculate_offsets
      end

      def draw
        draw_legend_text
        draw_legend_color_indicator # FIXME: make a new Artist::Rectangle object.
      end

      private

      def draw_legend_text
        @legends.each do |legend|
          scaled_width = @artist.geometry.raw_columns * @artist.scale
          scaled_width = scaled_width >=1 ? scaled_width : 1
          @artist.backend.draw_text(legend,
                                    font_color: @font_color,
                                    font: @font,
                                    pointsize: @font_size * @artist.scale,
                                    stroke: 'transparent',
                                    font_weight: Magick::NormalWeight,
                                    gravity: Magick::WestGravity,
                                    width: scaled_width,
                                    height: 1.0,
                                    x: @current_x_offset + (@legend_box_size * 1.7),
                                    y: @current_y_offset
                                   )
        end
      end

      def draw_legend_color_indicator
        @artist.backend.draw_rectangle(x1: @current_x_offset,
                                       y1: @current_y_offset - @legend_box_size/2.0,
                                       x2: @current_x_offset + @legend_box_size,
                                       y2: @current_y_offset + @legend_box_size/2.0,
                                       fill: @colors[0],
                                       stroke: 'transparent'
                                      )
      end
      
      # FIXME: should work for multiple legends.
      def calculate_offsets
        @current_x_offset = (@artist.geometry.raw_columns -
                             @label_widths.first.inject(:+))/2
        @current_y_offset = if @artist.geometry.legend_at_bottom
                              @artist.graph_height + @axes.title_margin
                            else
                              if @artist.geometry.hide_title
                                @artist.geometry.top_margin + @axes.title_margin
                              else
                                @artist.geometry.top_margin +
                                  @axes.title_margin + @artist.title_caps_height
                              end                       
                            end
      end
      
      def calculate_legend_size
        # FIXME: below array consists of two arrays. If the legend overflows into another line,
        # it removes the element from the first array and put it in the second array.
        # so basically first array is for legends which have not overflowed and the second
        # is one which have. possibly rethink this data structure.
        @label_widths = [[]] # for calculating line wrap
        @legends.each do |legend|
          width, _ = @artist.backend.get_text_width_height legend
          label_width = width + @legend_box_size * 2.7 # FIXME: make value a global constant
          @label_widths.last.push label_width

          if @label_widths.last.inject(:+) > (@artist.geometry.raw_columns * 0.9)
            @label_widths.push [@label_widths.last.pop]
          end
        end
      end
    end # class Legend
  end # class Artist
end
