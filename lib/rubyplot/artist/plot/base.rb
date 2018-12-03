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
          @axes.geometry.column_count = y_values.length > @axes.geometry.column_count ?
                                     y_values.length : @axes.geometry.column_count

          # FIXME: move this to XAxis and YAxis later.
          # Pre-normalize => Set the max and min values of the data.
          y_values.each do |val|
            # Initialize the maximum and minimum values so that the spread starts
            # at the lowest points in the data and then changes as iteration.
            if @axes.geometry.y_max_value.nil? && @axes.geometry.y_min_value.nil?
              @axes.geometry.y_max_value = @axes.geometry.y_min_value = val
            end
            @axes.geometry.y_max_value = val > @axes.geometry.y_max_value ?
                                      val : @axes.geometry.y_max_value
            @axes.geometry.y_min_value = val < @axes.geometry.y_min_value ?
                                      val : @axes.geometry.y_min_value
            @axes.geometry.has_data = true
          end
        end
      end # class Base
    end # module Plot
  end # module Artist
end # module Rubyplot

