module Rubyplot
  module Artist
    module Plot
      class ErrorBar < Artist::Plot::Base
        attr_accessor :x, :y, :xerr, :yerr
        
        def initialize(*)
          super
        end

        def process_data
          super
        end

        def draw
          
        end
      end # class ErrorBar
    end # module Plot
  end # module Artist
end # module Rubyplot
