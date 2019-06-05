module Rubyplot
  module Artist
    module Plot
      class BasicPlot < Artist::Plot::Base
        attr_accessor :marker
        attr_accessor :marker_size
        
        def initialize(*)
          super
          @marker = :dot
          @marker_size = 1.0
        end

        def draw
          line_style = @marker.to_s.match /(.*)_line\z/
          if line_style
            Rubyplot::Artist::Line2D.new(
              self,
              x: @data[:x_values],
              y: @data[:y_values],
              type: line_style[1].to_sym,
              color: @data[:color]
            ).draw
          else
            # FIXME: this should probably be inside a 'Collections' class that will
            # allow the user to customise individual parameters.
            Rubyplot.backend.draw_markers(
              x: @data[:x_values],
              y: @data[:y_values],
              type: @marker,
              fill_color: @data[:color],
              size: [@marker_size] * @data[:x_values].size
            )
          end
        end
      end # class BasicPlot
    end # module Plot
  end # module Artist
end # module Rubyplot
