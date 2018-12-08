module Rubyplot
  module Utils
    THOUSAND_SEPARATOR = ','
    class << self
      def format_label label
        if label.is_a? Float
          format('%0.2f', label)
        end
      end
    end
  end # module Utils
end # module Rubyplot
