module Rubyplot
  module MagickWrapper    
    class Artist
      module Attributes
        # Blank space below the title
        attr_accessor :title_margin

        # Blank space below the legend
        attr_accessor :legend_margin

        # A hash of names for the individual columns, where the key is the array
        # index for the column this label represents.
        #
        # Not all columns need to be named.
        #
        # Example: 0 => 2005, 3 => 2006, 5 => 2007, 7 => 2008
        attr_accessor :labels

        # Used internally for horizontal graph types.
        attr_accessor :has_left_labels

        # A label for the bottom of the graph
        attr_accessor :x_axis_label

        # A label for the left side of the graph
        attr_accessor :y_axis_label

        # The large title of the graph displayed at the top
        attr_accessor :title

        # Font used for titles, labels, etc.
        # The font= method below fulfills the role of the writer, so we only need
        # a reader here.
        attr_reader :font

        attr_accessor :font_color

        # Prevent drawing of the legend
        attr_accessor :hide_legend

        # Prevent drawing of line numbers
        attr_accessor :hide_line_numbers

        # Optionally set the size of the font. Based on an 800x600px graph.
        # Default is 20.
        #
        # Will be scaled down if the graph is smaller than 800px wide.
        attr_accessor :legend_font_size

        # The number of horizontal lines shown for reference
        attr_accessor :marker_count

        # The color of the auxiliary lines
        attr_accessor :marker_color
        attr_accessor :marker_shadow_color

        # You can manually set a minimum value instead of having the values
        # guessed for you.
        #
        # Set it after you have given all your data to the graph object.
        attr_accessor :minimum_value

        # You can manually set a maximum value, such as a percentage-based graph
        # that always goes to 100.
        #
        # If you use this, you must set it after you have given all your data to
        # the graph object.
        attr_accessor :maximum_value

        # Accessor base image
        attr_accessor :base_image

        # Axes object to which this plot belongs.
        attr_reader :axes
      end # module Attributes
    end # class Artist
  end # module MagickWrapper
end # module Rubyplot
