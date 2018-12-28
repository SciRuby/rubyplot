require 'spec_helper'

describe Rubyplot::SPI do
  before do
    @x1 = [-10, 0, 5, 28]
    @y1 = [1, 2, 3, 4]
    @x2 = [2, 4, 16]
    @y2 = [10, 20, -40]
  end
  
  after do
    File.delete 'spec/reference_images/file_name.bmp'
  end

  context '#line! #scatter!' do
    before do
      @x1 = [-10, 0, 5, 28]
      @y1 = [1, 2, 3, 4]
      @x2 = [2, 4, 16]
      @y2 = [10, 20, -40]
    end
    skip 'creates a line and scatter graph' do
      a = Rubyplot::SPI.new
      a.title = 'My cool graph'
      a.line! @x1, @y1
      a.scatter! @x2, @y2
      a.save 'spec/reference_images/file_name.bmp'

      expect(compare_with_reference?('file_name.bmp', 'multi_plot_graph/' \
                                     'line_scatter_graph.bmp',10)).to eq(true)
    end
  end
end
