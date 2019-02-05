module Rubyplot
  module Artist
    class Tick
      class Base < Artist::Base
        DEFAULT_MAJOR_TICK_LENGTH = 1.0
        DEFAULT_MAJOR_TICK_LABEL_DISTANCE = 3.0
        
        # Distance between tick mark and number.
        attr_reader :label_distance
        # Label of this Tick
        attr_reader :label
        attr_reader :tick_opacity
        attr_reader :tick_width

        # @param owner [Rubyplot::Artist] Artist that owns this tick.
        # @param coord [Numeric] Co-ordinate value of this tick on the Axis.
        # @param length [Integer] Length of the tick.
        # @param label [String] Label below the tick.
        # @param label_distance [Integer] Distance between the label and tick.
        # @param tick_opacity [Float] Number describing the opacity of the tick drawn. 0-1.0.

        # rubocop:disable Metrics/ParameterLists
        def initialize(owner,coord:,length: nil,label:,label_distance: nil,
                       tick_opacity: 0.0,tick_width: 1.0)
          @owner = owner
          @coord = coord
          @length = length || DEFAULT_MAJOR_TICK_LENGTH
          @label_text = label # Rubyplot::Utils.format_label label
          @label_distance = label_distance || DEFAULT_MAJOR_TICK_LABEL_DISTANCE
          @tick_opacity = tick_opacity
          @tick_width = tick_width
        end
        # rubocop:enable Metrics/ParameterLists
      end # class Base
    end # class Tick
  end # class Artist
end # module Rubyplot
