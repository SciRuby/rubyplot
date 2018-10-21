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
      @subplots = Array.new(nrows) { Array.new(ncols) { Rubyplot::Axes.new } }
    end

    def add_subplot nrow, ncol
      @subplots[nrow][ncol]
    end

    def write file_name
      
    end
  end
end
