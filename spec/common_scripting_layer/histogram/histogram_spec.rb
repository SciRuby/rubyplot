context :Histogram do
  it 'Sets up a basic reference image for histogram with random numbers' do
    plot = Rubyplot::Histogram.new(600)
    plot.title = 'Random Histogram Numbers'
    plot.marker_count = 8
    plot.data('data', [5, 12, 9, 6, 7])
    plot.write('spec/reference_images/histogram_test_1.png')

    expect(compare_with_reference?('histogram.png', 'histogram_test_1.png', 10)).to eq(true)
  end

  it 'fails to match with the reference image as the data values are different' do
    plot = Rubyplot::Histogram.new(600)
    plot.title = 'Random Histogram Numbers'
    plot.marker_count = 8
    plot.data('data', [5, 12, 9, 6, 6])
    # the data is different from the reference image.
    plot.write('spec/reference_images/histogram_test_2.png')

    expect(compare_with_reference?('histogram.png', 'histogram_test_2.png', 10)).to eq(false)
  end

  it 'makes histogram with large datapoints' do
    # Checks if the graph values don't go off the chart on setting very high values.
    plot = Rubyplot::Histogram.new(600)
    plot.title = 'Large Number'
    plot.marker_count = 8
    plot.data('data', [7025, 1024, 40_257, 933_672, 1_560_496])

    plot.write('spec/reference_images/histogram_geometry_test.png')
  end

  it 'tests setting x axis labels for histogram' do
    plot = Rubyplot::Histogram.new
    plot.title = 'Pos/Neg Bar Graph Test'
    plot.labels = {
      0 => '5/6',
      1 => '5/15',
      2 => '5/24',
      3 => '5/30'
    }
    plot.data(:apples, [7025, 1024, 40_257, 933_672, 1_560_496], [4, 13, 15, 20, 29])
    plot.write('spec/reference_images/histogram_pos_neplot_test.png')
  end
end
