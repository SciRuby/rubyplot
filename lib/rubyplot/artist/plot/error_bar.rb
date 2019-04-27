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
          size = @data[:y_values].size
          @yuplims = Array.new(size) { nil } unless @yuplims
          @ylolims = Array.new(size) { nil } unless @ylolims
          @xuplims = Array.new(size) { nil } unless @xuplims
          @xlolims = Array.new(size) { nil } unless @xlolims

          check_lims_sizes
          check_err_sizes

          if @yerr
          end
        end

        def draw

        end

        private

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
