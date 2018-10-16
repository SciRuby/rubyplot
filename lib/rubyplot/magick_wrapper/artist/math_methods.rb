module Rubyplot
  module MagickWrapper
    class Artist
      module MathMethods
        # Make copy of data with values scaled between 0-100
        # TODO: Add spec for this method.
        def normalize
          @geometry.norm_data = []
          @data.each do |data_row|
            norm_data_points = []
            data_row[DATA_VALUES_INDEX].each do |data_point|
              norm_data_points << ((data_point.to_f - @geometry.minimum_value.to_f) / @spread)
              # Add support for nil values in data etc.
            end
            @geometry.norm_data << [data_row[DATA_LABEL_INDEX], norm_data_points]
          end
        end

        def clip_value_if_greater_than(value, max_value) # :nodoc:
          value > max_value ? max_value : value
        end

        # Calculates the spread of the data.
        def calculate_spread
          @spread = @geometry.maximum_value.to_f - @geometry.minimum_value.to_f
        end

        # Return the sum of values in an array.
        def sum(arr)
          arr.inject(0) { |i, m| m + i }
        end

        ##
        # Return a calculation of center
        def center(size)
          (@geometry.raw_columns - size) / 2
        end

        # Return a comparable fontsize for the current graph.
        def scale_fontsize(value)
          value * @scale
        end

        def significant(i)
          return 1.0 if i == 0 # Keep from going into infinite loop
          inc = BigDecimal(i.to_s)
          factor = BigDecimal('1.0')
          while inc < 10
            inc *= 10
            factor /= 10
          end

          while inc > 100
            inc /= 10
            factor *= 10
          end

          res = inc.floor * factor
          if res.to_i.to_f == res
            res.to_i
          else
            res
          end
        end

        # Sort with largest overall summed value at front of array so it shows up
        # correctly in the drawn graph.
        def sort_norm_data
          @geometry.norm_data =
            @geometry.norm_data.sort_by { |a| -a[DATA_VALUES_INDEX].inject(0) { |sum, num| sum + num.to_f } }
        end

        # Returns the height of the capital letter 'X' for the current font and
        # size.
        #
        # Not scaled since it deals with dimensions that the regular scaling will
        # handle.
        def calculate_caps_height(font_size)
          @d.pointsize = font_size
          @d.font = @font if @font
          @d.get_type_metrics(@base_image, 'X').height
        end

        # Returns the width of a string at this pointsize.
        #
        # Not scaled since it deals with dimensions that the regular
        # scaling will handle.
        def calculate_width(font_size, text)
          return 0 if text.nil?
          @d.pointsize = font_size
          @d.font = @font if @font
          @d.get_type_metrics(@base_image, text.to_s).width
          # get_type_metrics function returns information for a specific string if rendered on a image.
          # It's extreemly useful for understanding positioning and location of text.
          # This will be used to identify positioning of text.
        end
      end
    end
  end
end
