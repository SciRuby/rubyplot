module Rubyplot
  module Artist
    class Tick
      class Base
        # Distance between tick mark and number.
        attr_reader :label_distance

        # Label of this Tick
        attr_reader :label

        # @param x [Integer] X co-ordinate of the origin of this tick.
        # @param y [Integer] Y co-ordinate of the origin of this tick.
        # @param length [Integer] Length of the tick.
        # @param label [String] Label below the tick.
        # @param label_distance [Integer] Distance between the label and tick.
        def initialize(artist,x:,y:,length:,label:,label_distance:)
          @artist = artist
          @x = x
          @y = y
          @length = length
          @label_text = label
          @label_distance = label_distance
        end
      end # class Base
    end # class Tick
  end # class Artist
end # module Rubyplot
