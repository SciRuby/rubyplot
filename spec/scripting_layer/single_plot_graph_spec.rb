require 'spec_helper'

describe Rubyplot::Figure do
  before do
    @x1 = [1, 2, 3, 4, 5]
    @y1 = [10, 20, 30, 40, 50]
    @values = [0, 24, -12, 48]
    @freqwise = [1, 2, 5, 6, 5, 9, 9, 1, 2, 9, 2, 6, 5]
    @portfolio_names = ['Apples', 'Oranges', 'Bananas']
    @portfolio = [20000, 8000, 34000]
  end
  after do
    File.delete 'spec/reference_images/file_name.bmp'
  end

  context '#line' do
    it 'creates a simple line graph' do
      a = Rubyplot::Figure.new
      a.line! @x1, @y1
      a.save 'spec/reference_images/file_name.bmp'

      expect(compare_with_reference?('file_name.bmp', 'single_plot_graph/' \
                                     'line_graph.bmp', 10)).to eq(true)
    end

    it 'creates a line graph with points marked' do
      a = Rubyplot::Figure.new
      a.line! @x1, @y1, marker_size: 1
      a.save 'spec/reference_images/file_name.bmp'

      expect(compare_with_reference?('file_name.bmp', 'single_plot_graph/' \
                                     'line_marker_graph.bmp', 10)).to eq(true)
    end

    it 'creates a red dashed line graph with points marked' do
      a = Rubyplot::Figure.new
      a.line! @x1, @y1, line_color: :red, line_type: :dashed
      a.save 'spec/reference_images/file_name.bmp'

      expect(compare_with_reference?('file_name.bmp', 'single_plot_graph/' \
                                     'dash_line_marker_graph.bmp',
                                     10)).to eq(true)
    end
  end

  context '#scatter!', focus: true do
    it 'creates a simple scatter graph' do
      a = Rubyplot::Figure.new
      a.scatter! do |p|
        p.data @x1, @y1
      end
      a.save 'spec/reference_images/file_name.bmp'

      expect(compare_with_reference?('file_name.bmp', 'single_plot_graph/' \
                                     'scatter_graph.bmp', 10)).to eq(true)
    end

    it 'creates a green cross scatter graph' do
      a = Rubyplot::Figure.new
      a.scatter! @x1, @y1, marker_color: :green, marker_size: 2,
                           marker_type: :diagonal_cross
      a.save 'spec/reference_images/file_name.bmp'

      expect(compare_with_reference?('file_name.bmp', 'single_plot_graph/' \
                                     'scatter_cross_graph.bmp', 10)).to eq(true)
    end
  end

  context '#bar' do
    it 'creates a simple bar graph' do
      a = Rubyplot::Figure.new
      a.bar! @values
      a.save 'spec/reference_images/file_name.bmp'

      expect(compare_with_reference?('file_name.bmp', 'single_plot_graph/' \
                                    'bar_graph.bmp', 10)).to eq(true)
    end

    it 'creates a bar graph with red color bars' do
      a = Rubyplot::Figure.new
      a.bar! @values, bar_color: :red
      a.save 'spec/reference_images/file_name.bmp'

      expect(compare_with_reference?('file_name.bmp', 'single_plot_graph/' \
                                     'red_bar_graph.bmp', 10)).to eq(true)
    end

    it 'creates a bar graph with orange color bars with spaces' do
      a = Rubyplot::Figure.new
      a.bar! @values, bar_color: :orange, bar_gap: 1
      a.save 'spec/reference_images/file_name.bmp'

      expect(compare_with_reference?('file_name.bmp', 'single_plot_graph/' \
                                     'orange_spaced_bar_graph.bmp',
                                     10)).to eq(true)
    end
  end

  context '#stacked_bar!' do
    before do
      @bars_data = [[12, 4, 53, 24],
                    [4, 34, 8, 25],
                    [20, 9, 31, 2],
                    [56, 12, 84, 30]]
    end

    it 'creates a stacked bar graph' do
      a = Rubyplot::Figure.new
      a.stacked_bar! @bars_data
      a.save 'spec/reference_images/file_name.bmp'

      expect(compare_with_reference?('file_name.bmp', 'single_plot_graph/' \
                                     'stacked_bar_graph.bmp',
                                     10)).to eq(true)
    end

    it 'creates a stacked bar graph with user defined colors' do
      a = Rubyplot::Figure.new
      a.stacked_bar! @bars_data,bar_colors: [:black, :red, :green, :blue]
      a.save 'spec/reference_images/file_name.bmp'

      expect(compare_with_reference?('file_name.bmp', 'single_plot_graph/' \
                                     'user_color_stacked_bar_graph.bmp',
                                     10)).to eq(true)
    end
  end

  context '#stacked_bar_z!' do
    before do
      @bars_data = [[12, 4, 53, 24],
                    [4, 34, 8, 25],
                    [20, 9, 31, 2],
                    [56, 12, 84, 30]]
    end

    it 'creates a stacked bar Z graph' do
      a = Rubyplot::Figure.new
      a.stacked_bar_z! @bars_data
      a.save 'spec/reference_images/file_name.bmp'

      expect(compare_with_reference?('file_name.bmp', 'single_plot_graph/' \
                                     'stacked_bar_z_graph.bmp',
                                     10)).to eq(true)
    end

    it 'creates a stacked bar Z graph with user defined colors' do
      a = Rubyplot::Figure.new
      a.stacked_bar! @bars_data,bar_colors: [:black, :red, :green, :blue]
      a.save 'spec/reference_images/file_name.bmp'

      expect(compare_with_reference?('file_name.bmp', 'single_plot_graph/' \
                                     'user_color_stacked_bar_z_graph.bmp',
                                     10)).to eq(true)
    end
  end

  context '#line_plot!' do
    it 'creates a simple line plot' do
      a = Rubyplot::Figure.new
      a.line_plot_z! @freqwise
      a.save 'spec/reference_images/file_name.bmp'

      expect(compare_with_reference?('file_name.bmp', 'single_plot_graph/' \
                                     'line_plot.bmp', 10)).to eq(true)
    end

    it 'creates a line plot with red markers' do
      a = Rubyplot::Figure.new
      a.line_plot! @values, marker_color: :red, marker_size: 2
      a.save 'spec/reference_images/file_name.bmp'

      expect(compare_with_reference?('file_name.bmp', 'single_plot_graph/' \
                                     'red_line_plot.bmp', 10)).to eq(true)
    end

    it 'creates a line plot with green solid bowtie markers' do
      a = Rubyplot::Figure.new
      a.line_plot! @values, marker_color: :green, marker_type: :solid_bowtie
      a.save 'spec/reference_images/file_name.bmp'

      expect(compare_with_reference?('file_name.bmp', 'single_plot_graph/' \
                                     'green _bowtie_line_plot.bmp',
                                     10)).to eq(true)
    end
  end

  context '#pie!' do
    it 'creates a simple pie chart' do
      a = Rubyplot::Figure.new
      a.pie! @portfolio, @portfolio_names
      a.save 'spec/reference_images/file_name.bmp'

      expect(compare_with_reference?('file_name.bmp', 'single_plot_graph/' \
                                     'pie_chart.bmp', 10)).to eq(true)
    end
  end

  context '#candlestick!' do
    before do
      @open = [10, 15, 24, 18]
      @high = [20, 25, 30, 18]
      @low = [5, 13, 15, 3]
      @close = [15, 24, 18, 4]
      # incoporate date ??
    end
    it 'creates a simple candle plot' do
      a = Rubyplot::Figure.new
      a.candlestick! @open, @high, @low, @close
      a.save 'spec/reference_images/file_name.bmp'

      expect(compare_with_reference?('file_name.bmp', 'single_plot_graph/' \
                                     'candlestick_plot.bmp',
                                     10)).to eq(true)
    end

    it 'creates a candle plot with blue positive and black negative color' do
      a = Rubyplot::Figure.new
      a.candlestick! @open, @high, @low, @close, up_color: :blue, down_color: :black
      a.save 'spec/reference_images/file_name.bmp'

      expect(compare_with_reference?('file_name.bmp', 'single_plot_graph/' \
                                     'candlestick_plot.bmp',
                                     10)).to eq(true)
    end
  end
end
