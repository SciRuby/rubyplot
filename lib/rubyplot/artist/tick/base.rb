module Rubyplot
  module Artist
    class Tick
      class Base < Artist::Base
        # Label of this Tick
        attr_reader :label
        attr_reader :tick_opacity
        attr_reader :tick_width
        attr_reader :tick_size


        # @param owner [Rubyplot::Artist] Artist that owns this tick.
        # @param coord [Float] Co-ordinate on the Axes on which this tick exists.
        # @param label [String] Label below the tick.
        # @param label_distance [Integer] Distance between the label and tick.
        # @param tick_opacity [Float] Number describing the opacity of the tick drawn. 0-1.0.
        # @param tick_size [Float] Size of the ticks in terms of Rubyplot Artist Co-ordinates.
        # rubocop:disable Metrics/ParameterLists
        def initialize(owner, coord:, label:,label_distance: nil,
          tick_opacity: 0.0, tick_width: 1.0, tick_size: 1.0)
          @owner = owner
          @coord = coord
          @label = label
          @tick_opacity = tick_opacity
          @tick_width = tick_width
          @tick_size = tick_size
        end
        # rubocop:enable Metrics/ParameterLists
      end # class Base
    end # class Tick
  end # class Artist
end # module Rubyplot
