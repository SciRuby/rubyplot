module Rubyplot
  module Artist
    module Plot
      class Scatter < Artist::Plot::Base
        attr_reader :geometry
        
        def initialize(*)
          super
        end
        
        def data x_values, y_values
          super y_values
          @data[:x_values] = x_values
          if @geometry.x_max_value.nil? && @geometry.x_min_value.nil?
            @geometry.x_max_value = @geometry.x_min_value = x_values.first
          end
          @geometry.x_max_value = x_values.max > @geometry.x_max_value ?
                                    x_values.max : @geometry.x_max_value
          @geometry.x_min_value = x_values.min < @geometry.x_min_value ?
                                    x_values.min : @geometry.x_min_value
        end
      end
    end
  end
end
