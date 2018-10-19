module Rubyplot
  class Figure
    def initialize
      @nrows = 1
      @ncols = 1
      @subplots = [[Rubyplot::Axes.new]]
      @active_subplot = @subplots[0][0]
    end

    def scatter! *args, &block
      scatter = with_backend :scatter, args
      yield(scatter) if block_given?
      scatter.commit!
    end

    private
 
    def with_backend name, *args
      plot_name = name.to_s.capitalize

      plot =
      case Rubyplot.backend
      when :magick
        Kernel.const_get("Rubyplot::MagickWrapper::Plot::#{plot_name}").new #*args
      when :gr
        Kernel.const_get("Rubyplot::GRWrapper::Plot::#{plot_name}").new #*args
      end

      @active_subplot.add_plot plot
      plot
    end
  end
end
