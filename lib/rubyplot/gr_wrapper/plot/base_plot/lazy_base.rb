module Rubyplot
  module GRWrapper
    module Plot
      module BasePlot
        class LazyBase
          attr_reader :plot_type
          def initialize
            @tasks = []
            @plot_type = :robust
          end

          def call
            @tasks.each do |task|
              task.call()
            end
          end
        end
      end
    end
  end
end
