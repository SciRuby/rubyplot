module Rubyplot
  class Figure
    attr_reader :title, :nrows, :ncols
    
    def initialize
      @title = ''
      @nrows = 1
      @ncols = 1
      add_subplots @nrows, @ncols
    end

    def add_subplots nrows, ncols
      @subplots = Array.new(nrows) { Array.new(ncols) { nil } }
    end

    def add_subplot nrow, ncol
      @subplots[nrow][ncol] = Rubyplot::Axes.new
    end

    def write file_name
      @subplots[0][0].write file_name
    end
  end
end
