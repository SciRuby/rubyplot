require 'spec_helper'

Rubyplot.describe Rubyplot::Axes do
  context "#line!" do
    
  end

  context "#scatter!" do
    before do
      @x1 = [1, 2, 3, 4, 5]
      @y1 = [10, 20, 30, 40, 50]
    end
    
    it "adds a simple scatter plot." do
      fig = Rubyplot::Figure.new
      axes = fig.add_subplot 1,1,1
      axes.scatter! do |p|
        p.data @x1, @y1
      end
    end

    it "adds a green cross scatter plot." do
      fig = Rubyplot::Figure.new
      axes = fig.add_subplot 1,1,1
      axes.scatter! do |p|
        p.data @x1, @y1
        p.color = :green
        p.size = 2
        p.type = :diagonal_cross
      end
    end
  end
end
