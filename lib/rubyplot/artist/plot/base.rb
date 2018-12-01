module Rubyplot
  module Artist
    module Plot
      class Base
        attr_reader :axes, :data
        
        def initialize axes
          @axes = axes
          @data = {
            label: :default,
            color: :default
          }
        end

        def data y_values
          @data[:y_values] = y_values
          # Set column count if this is larger than previous column counts
          @geometry.column_count = y_values.length > @geometry.column_count ?
                                     y_values.length : @geometry.column_count

          # FIXME: move this to XAxis and YAxis later.
          # Pre-normalize => Set the max and min values of the data.
          y_values.each do |val|
            # Initialize the maximum and minimum values so that the spread starts
            # at the lowest points in the data and then changes as iteration.
            if @geometry.y_max_value.nil? && @geometry.y_min_value.nil?
              @geometry.y_max_value = @geometry.y_min_value = val
            end
            @geometry.y_max_value = val > @geometry.y_max_value ?
                                      val : @geometry.y_max_value
            @geometry.y_min_value = val < @geometry.y_min_value ?
                                      val : @geometry.y_min_value
            @geometry.has_data = true
          end
        end
      end
    end
  end
end

