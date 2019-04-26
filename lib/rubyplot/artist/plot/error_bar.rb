module Rubyplot
  module Artist
    module Plot
      class ErrorBar < Artist::Plot::Base
        attr_accessor :xerr, :yerr, :xuplims, :xlolims, :yuplims, :xlolims
        
        def initialize(*)
          super
        end

        def process_data
          super
          init_lims! [@xuplims, @xlolims, @yuplims, @ylolims]

        end

        def draw

        end

        private

        def init_lims! arr
          arr.map! do |a|
            Arrary.new(@data[:y_values].size) { nil } unless a
          end
        end
      end # class ErrorBar
    end # module Plot
  end # module Artist
end # module Rubyplot
