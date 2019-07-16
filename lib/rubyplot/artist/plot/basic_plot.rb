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
        attr_accessor :fmt

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

        def draw
          # Default marker fill color
          @marker_fill_color = :default if @marker_fill_color.nil?
          # defualt type of plot is solid line
          @line_type = :solid if @line_type.nil? && @marker_type.nil?
          # line_style = @marker.to_s.match /(.*)_line\z/
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
