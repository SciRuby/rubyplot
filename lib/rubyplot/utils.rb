module Rubyplot
  module Utils
    THOUSAND_SEPARATOR = ','.freeze
    class << self
      def format_label label
        if label.is_a? Numeric
          '%0.2f' % label
        elsif label.is_a? String
          label
        end
      end
    end
  end
  # module Utils
end
# module Rubyplot
