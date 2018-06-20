require 'spec_helper'

describe Rubyplot do
  before do
    @x1 = [-10, 0 , 5, 28] 
    @y1 = [1, 2, 3, 4]
    @x2 = [2, 4, 16]
    @y2 = [10, 20, -40]
  end

  context "#line #scatter" do
    it "creates a line and scatter graph" do
      a = Rubyplot.new
      a.line @x1, @y1
      a.scatter @x2, @y2
      a.save "file_name.bmp"

      expect(equal_files("file_name.bmp","line_scatter_graph.bmp")).to eq(true)
    end
  end
end