module Rubyplot
  module Artist
    module Plot
      class ErrorBar < Artist::Plot::Base
        attr_accessor :xerr
        attr_accessor :yerr, :xuplims, :xlolims, :yuplims, :ylolims
        
        def initialize(*)
          super
        end

        def process_data
          super
          preprocess_err_values!
          
          check_lims_sizes
          check_err_sizes

          adjust_axes_ranges!
          @line = Rubyplot::Artist::Line2D.new(
            self,
            x: @data[:x_values],
            y: @data[:y_values],
            color: @data[:color]
          )
          generate_yerr if @yerr
          generate_xerr if @xerr
        end

        def draw
          @line.draw
          @yerr_lines.each(&:draw) if @yerr_lines
          @xerr_lines.each(&:draw) if @xerr_lines
        end

        private

        def adjust_axes_ranges!
          if @xerr
            @axes.x_axis.max_val = @data[:x_values].max + @xerr.max
            @axes.x_axis.min_val = @data[:x_values].min - @xerr.min
          end
          
          if @yerr
            @axes.y_axis.max_val = @data[:y_values].max + @yerr.max
            @axes.y_axis.min_val = @data[:y_values].min - @yerr.min
          end
        end

        def preprocess_err_values!
          if @yerr
            if @yerr.is_a?(Float)
              @yerr = [@yerr] * @data[:y_values].size
            end
          end

          if @xerr
            if @xerr.is_a?(Float)
              @xerr = [@xerr] * @data[:x_values].size
            end
          end
        end

        def generate_xerr
          @xerr_lines = @xerr.map.with_index do |xe, idx|
            xcoord = @data[:x_values][idx]
            ycoord = @data[:y_values][idx]

            if !@xuplims && !@xlolims
              Rubyplot::Artist::Line2D.new(
                self,
                x: [xcoord - xe, xcoord + xe],
                y: [ycoord, ycoord],
                color: @data[:color]
              )
            else
              arrows = []
              if @xuplims && @xuplims[idx]
                arrows << Rubyplot::Artist::Arrow.new(
                  x1: xcoord,
                  y1: ycoord,
                  x2: xcoord + xe,
                  y2: ycoord
                )
              end

              if @xlolims && @xlolims[idx]
                arrows << Rubyplot::Artist::Arrow.new(
                  x1: xcoord,
                  y1: ycoord,
                  x2: xcoord - xe,
                  y2: ycoord                  
                )
              end
              arrows
            end
          end
          @xerr_lines.flatten!
        end

        def generate_yerr
          @yerr_lines = @yerr.map.with_index do |ye, idx|
            xcoord = @data[:x_values][idx]
            ycoord = @data[:y_values][idx]

            if !@yuplims && !@ylolims
              Rubyplot::Artist::Line2D.new(
                self,
                x: [xcoord, xcoord],
                y: [ycoord - ye, ycoord + ye],
                color: @data[:color]
              )
            else
              arrows = []
              if @yuplims && @yuplims[idx]
                arrows << Rubyplot::Artist::Arrow.new(
                  x1: xcoord,
                  y1: ycoord,
                  x2: xcoord,
                  y2: ycoord + ye
                )
              end

              if @ylolims && @ylolims[idx]
                arrows << Rubyplot::Artist::Arrow.new(
                  x1: xcoord,
                  y1: ycoord,
                  x2: xcoord,
                  y2: ycoord - ye               
                )
              end
              arrows
            end
          end
          @yerr_lines.flatten!
        end

        def check_lims_sizes
          
        end

        def check_err_sizes
          if @yerr && @yerr.size != @data[:y_values].size
            raise Rubyplot::SizeError, "yerr.size != data(y_values).size. Must be the same."
          end

          if @xerr && @xerr.size != @data[:x_values].size
            raise Rubyplot::SizeError, "xerr.size != data(x_values).size. Must be the same."
          end
        end
      end # class ErrorBar
    end # module Plot
  end # module Artist
end # module Rubyplot
