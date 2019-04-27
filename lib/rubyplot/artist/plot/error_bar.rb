module Rubyplot
  module Artist
    module Plot
      class ErrorBar < Artist::Plot::Base
        attr_accessor :xerr
        attr_accessor :yerr, :xuplims, :xlolims, :yuplims, :xlolims
        
        def initialize(*)
          super
        end

        def process_data
          super
          
          preprocess_err_values!
          
          check_lims_sizes
          check_err_sizes

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
          @yerr_lines.each(&:draw) if @yerr
          @xerr_lines.each(&:draw) if @xerr
        end

        private

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
                  x1: xcoord - xe,
                  y1: ycoord,
                  x2: xcoord,
                  y2: ycoord                  
                )
              end
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
            end
          end
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
