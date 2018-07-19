describe 'Stacked Bar' do
  before do
    @datasets = [
      [:Car, [25, 36, 86, 39]],
      [:Bus, [80, 54, 67, 54]],
      [:Train, [22, 29, 35, 38]]
    ]
  end
  # Matplotlib reference -> https://matplotlib.org/gallery/lines_bars_and_markers/bar_stacked.html#sphx-glr-gallery-lines-bars-and-markers-bar-stacked-py

  it 'creates a Stacked Bar graph' do
    plot = Rubyplot::StackedBar.new
    plot.title = 'Visual Stacked Bar Graph Test'
    plot.labels = {
      0 => '5/6',
      1 => '5/15',
      2 => '5/24',
      3 => '5/30'
    }
    @datasets.each do |data|
      plot.data(data[0], data[1])
    end
    plot.write('spec/reference_images/stacked_bar_test_1.png')
    expect(compare_with_reference?('stacked_bar.png', 'stacked_bar_test_1.png', 10)).to eq(true)
  end

  it 'creates a Stacked Bar graph with preset size from the user' do
    plot = Rubyplot::StackedBar.new(400)
    plot.title = 'Stacked Bar'
    plot.labels = {
      0 => '5/6',
      1 => '5/15',
      2 => '5/24',
      3 => '5/30'
    }
    @datasets.each do |data|
      plot.data(data[0], data[1])
    end
    plot.write('spec/reference_images/stacked_bar_test_2.png')
  end
end
