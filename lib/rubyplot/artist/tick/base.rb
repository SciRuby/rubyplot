module Rubyplot
  module Artist
    class Tick
      class Base
        # Distance between tick mark and number.
        attr_reader :label_distance
        # Label of this Tick
        attr_reader :label
        attr_reader :tick_opacity
        attr_reader :tick_width

        # @param owner [Rubyplot::Artist] Artist that owns this tick.
        # @param x [Integer] X co-ordinate of the origin of this tick.
        # @param y [Integer] Y co-ordinate of the origin of this tick.
        # @param length [Integer] Length of the tick.
        # @param label [String] Label below the tick.
        # @param label_distance [Integer] Distance between the label and tick.
        # @param tick_opacity [Float] Number describing the opacity of the tick drawn. 0-1.0.
        def initialize(owner,x:,y:,length:,label:,label_distance:,
                       tick_opacity: 1.0,tick_width: 3.0)
          @owner = owner
          @x = x
          @y = y
          @length = length
          @label_text = label
          @label_distance = label_distance
          @tick_opacity = tick_opacity
          @tick_width = tick_width
        end
      end # class Base
    end # class Tick
  end # class Artist
end # module Rubyplot
