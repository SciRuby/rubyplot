require 'spec_helper'

describe Rubyplot::SPI do
  before do
    @x1 = [1, 2, 3, 4, 5]
    @y1 = [10, 20, 30, 40, 50]
    @x2 = [2, 4, 16]
    @y2 = [10, 20, -40]
    @values = [0, 24, -12, 48]
    @bars_data = [[12, 4, 53, 24],
                  [4, 34, 8, 25],
                  [20, 9, 31, 2],
                  [56, 12, 84, 30]]
    @open = [10, 15, 24, 18]
    @high = [20, 25, 30, 18]
    @low = [5, 13, 15, 3]
    @close = [15, 24, 18, 4]
  end
  after do
    File.delete 'spec/reference_images/file_name.bmp'
  end

  context '#subplot!' do
    it 'creates a SPI with 2 Subplots stacked vertically' do
      a = Rubyplot::SPI.new
      a.subplot!(2, 1, 1)
      a.line! @x1, @y1
      a.subplot!(2, 1, 2)
      a.scatter! @x2, @y2
      a.save 'spec/reference_images/file_name.bmp'

      expect(compare_with_reference?('file_name.bmp', 'subplots/' \
                                     'two_vertical.bmp', 10)).to eq(true)
    end

    it 'creates a 2x2 subplots with multiple plots in a figure' do
      a = Rubyplot::SPI.new
      a.subplot!(2, 2, 1)
      a.line! @x1, @y1, marker_size: 1
      a.scatter! @x2, @y2
      a.subplot!(2, 2, 2)
      a.scatter! @x2, @y2
      a.subplot!(2, 2, 3)
      a.line! @x1, @y1, line_color: :red, line_type: :dashed
      a.subplot!(2, 2, 4)
      a.candlestick! @open, @high, @low, @close, up_color: :blue, down_color: :black
      a.subplot!(2, 2, 3)
      a.bar! @values, bar_color: :orange, bar_gap: 1
      a.save 'spec/reference_images/file_name.bmp'

      expect(compare_with_reference?('file_name.bmp', 'subplots/' \
                                     'two_by_two_grid.bmp', 10)).to eq(true)
    end
  end
end
