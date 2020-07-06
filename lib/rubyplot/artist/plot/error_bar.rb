module Rubyplot
  module Artist
    module Plot
      class ErrorBar < Artist::Plot::Base
        attr_accessor :xuplims, :xlolims, :yuplims, :ylolims, :line_width, :xerr_width, :yerr_width, :xerr_color, :yerr_color
        attr_reader :xerr, :yerr

        def initialize(*)
          super
          @line_width = 1.0
          @xerr_width = 1.0
          @yerr_width = 1.0
          @xerr_color = nil
          @yerr_color = nil
        end

        def xerr=(xerror)
          if (xerror.is_a?(Float) || xerror.is_a?(Integer))
            @xerr = xerror
          else
            @xerr = xerror.to_a
          end
        end

        def yerr=(yerror)
          if (yerror.is_a?(Float) || yerror.is_a?(Integer))
            @yerr = yerror
          else
            @yerr = yerror.to_a
          end
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
            color: @data[:color],
            width: @line_width
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
                color: @xerr_color.nil? ? @data[:color] : @xerr_color,
                width: @xerr_width
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
                color: @yerr_color.nil? ? @data[:color] : @yerr_color,
                width: @yerr_width
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
