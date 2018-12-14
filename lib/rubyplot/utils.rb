module Rubyplot
  module Utils
    THOUSAND_SEPARATOR = ','.freeze
    class << self
      def format_label(label)
        '%0.2f' % label if label.is_a? Float
      end
    end
  end
  # module Utils
end
# module Rubyplot
