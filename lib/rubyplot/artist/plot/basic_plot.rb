module Rubyplot
  module Artist
    module Plot
      class BasicPlot < Artist::Plot::Base
        attr_accessor :marker_type
        attr_accessor :marker_size
        attr_accessor :marker_border_color
        attr_accessor :marker_fill_color
        attr_accessor :line_color
        attr_accessor :line_type
        attr_accessor :line_width
        attr_accessor :line_opacity

        COLOR_TYPES_FMT = {
          'b' => :blue,
          'g' => :green,
          'r' => :red,
          'c' => :cyan,
          'm' => :magenta,
          'y' => :yellow,
          'k' => :black,
          'w' => :white
        }.freeze

        MARKER_TYPES_FMT = {
          '.' => :dot,
          ',' => :omark,
          'o' => :circle,
          'v' => :traingle_down,
          '^' => :traingle_up,
          '<' => :solid_tri_left,
          '>' => :solid_tri_right,
          '1' => :solid_triangle_down,
          '2' => :solid_triangle_up,
          '3' => :solid_tri_left,
          '4' => :solid_tri_right,
          's' => :square,
          'p' => :pentagon,
          '*' => :star,
          'h' => :hexagon,
          'H' => :heptagon,
          '+' => :plus,
          'x' => :diagonal_cross,
          'D' => :solid_diamond,
          'd' => :diamond,
          '|' => :vline,
          '_' => :hline
        }

        LINE_TYPES_FMT ={
          '--' => :dashed,
          '-.' => :dashed_dotted,
          '-' => :solid,
          ':' => :dotted
        }

        def initialize(*)
          super
          @marker_type = nil
          @marker_size = 1.0
          @marker_border_color = :default
          # set fill to nil for the benefit of hollow markers so that legend
          # color defaults to :black in case user does not specify.
          @marker_fill_color = nil
          @line_color = :default
          @line_type = nil
          @line_width = 1.0
          @line_opacity = 1.0
          @fmt = nil
        end

        def color
          @line_color || @marker_fill_color || @marker_border_color || :default
        end

        def fmt=(fmt)
          unless fmt.is_a? String
            raise TypeError, 'fmt argument takes a String input'
          end

          COLOR_TYPES_FMT.each do |symbol, color|
            if fmt.include? symbol
              @marker_fill_color = color
              @marker_border_color = color
              @line_color = color
              break
            end
          end

          MARKER_TYPES_FMT.each do |symbol, marker_type|
            if fmt.include? symbol
              @marker_type = marker_type
              break
            end
          end

          LINE_TYPES_FMT.each do |symbol, line_type|
            if fmt.include? symbol
              @line_type = line_type
              break
            end
          end
        end

        def draw
          # Default marker fill color
          @marker_fill_color = :default if @marker_fill_color.nil?
          # defualt type of plot is solid line
          @line_type = :solid if @line_type.nil? && @marker_type.nil?
          Rubyplot::Artist::Line2D.new(
            self,
            x: @data[:x_values],
            y: @data[:y_values],
            type: @line_type,
            # type: line_style[1].to_sym,
            color: @line_color,
            opacity: @line_opacity,
            width: @line_width
          ).draw if @line_type
          Rubyplot.backend.draw_markers(
            x: @data[:x_values],
            y: @data[:y_values],
            type: @marker_type,
            fill_color: @marker_fill_color,
            border_color: @marker_border_color,
            size: [@marker_size] * @data[:x_values].size
          ) if @marker_type
        end
      end # class BasicPlot
    end # module Plot
  end # module Artist
end # module Rubyplot
