module Rubyplot
  class Figure
    DEFAULT_TARGET_WIDTH = 800  

    # Title on the figure.
    attr_reader :title
    # Number of Axes objects in the rows.
    attr_reader :nrows
    # Number of Axes objects in the cols.
    attr_reader :ncols
    # Drawing backend.
    attr_reader :backend
    # Total width of the Figure in pixels.
    attr_reader :width
    # Total height of the Figure in pixels.
    attr_reader :height
    
    def initialize
      @title = ''
      @nrows = 1
      @ncols = 1
      @backend = Rubyplot::Backend::MagickWrapper.new
      @width = DEFAULT_TARGET_WIDTH
      @height = @width * 0.75
      add_subplots @nrows, @ncols
    end

    def add_subplots nrows, ncols
      @subplots = Array.new(nrows) { Array.new(ncols) { nil } }
    end

    def add_subplot nrow, ncol
      @subplots[nrow][ncol] = Rubyplot::Artist::Axes.new(
        self, @width, @height, nrow*@ncols + ncol)
    end

    def write file_name
      @subplots[0][0].write file_name
    end
  end # class Figure
end # module Rubyplot
