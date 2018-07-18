require 'spec_helper'
describe :Bar do
  it 'sets up a basic reference image for bar graph with random numbers' do
    random_bar_graph
    plot = Rubyplot::Bar.new(600)
    plot.title = 'Random Bar Numbers'
    plot.marker_count = 8
    plot.data('data', [5, 12, 9, 6, 7])
    plot.write('spec/reference_images/bar_test_1.png')

    expect(compare_with_reference?('bar.png', 'bar_test_1.png', 10)).to eq(true)
  end

  it 'fails to match with the reference image as the data values are slightly different' do
    random_bar_graph
    plot = Rubyplot::Bar.new(600)
    plot.title = 'Random Bar Numbers'
    plot.marker_count = 8
    plot.data('data', [5, 12, 9, 6, 6])
    # the data is different from the reference image.
    plot.write('spec/reference_images/bar_test_2.png')

    expect(compare_with_reference?('bar.png', 'bar_test_2.png', 10)).to eq(false)
  end

  it 'constucts a bar graph with title margin' do
    # This margin width separates the actual plot from the title.
    bar_graph_with_title_margin
    plot = Rubyplot::Bar.new(600)
    plot.title = 'Random Bar numbers'
    plot.marker_count = 8
    plot.data('data', [5, 12, 9, 6, 6])
    plot.title = 'Bar Graph with Title Margin = 100'
    plot.title_margin = 100 # Set Title Margin.
    plot.write('spec/reference_images/bar_title_test.png')

    expect(compare_with_reference?('bar_title.png', 'bar_title_test.png', 10)).to eq(true)
  end

  it 'tests the bar graph geometry for large numbers' do
    # Checks if the graph values don't go off the chart on setting very high values.
    plot = Rubyplot::Bar.new(600)
    plot.title = 'Large Number'
    plot.marker_count = 8
    plot.data('data', [7025, 1024, 40_257, 933_672, 1_560_496])
    plot.write('spec/reference_images/bar_geometry_test.png')
  end

  it 'sets X_Y_labels for a graph' do
    plot = setup_basic_bar_graph(400)
    plot.title = 'X Y Labels'
    plot.x_axis_label = 'Score (%)'
    plot.y_axis_label = 'Students'
    plot.write('spec/reference_images/bar_x_y_labels_test.png')
  end

  it 'makes wide graph with dimensions preset by users' do
    plot = setup_basic_bar_graph('800x400')
    plot.title = 'Wide Graph'
    plot.write('spec/reference_images/bar_wide_graph_test.png')

    plot = setup_basic_bar_graph('400x200')
    plot.title = 'Wide Graph Small'
    plot.write('spec/reference_images/bar_wide_graph_small_test.png')
  end

  it 'makes a tall graph' do
    plot = setup_basic_bar_graph('400x600')
    plot.title = 'Tall Graph'
    plot.write('spec/reference_images/bar_tall_graph_test.png')

    plot = setup_basic_bar_graph('200x400')
    plot.title = 'Tall Graph Small'
    plot.write('spec/reference_images/bar_tall_graph_small_test.png')
  end

  it 'makes a bar graph with both positive and negative values' do
    plot = Rubyplot::Bar.new
    plot.title = 'Pos/Neg Bar Graph Test'
    plot.labels = {
      0 => '5/6',
      1 => '5/15',
      2 => '5/24',
      3 => '5/30'
    }
    plot.data(:apples, [-1, 0, 4, -4])
    plot.data(:peaches, [10, 8, 6, 3])

    plot.write('spec/reference_images/bar_pos_neplot_test.png')
  end

  it 'makes a bar graph with negative values only' do
    plot = Rubyplot::Bar.new
    plot.title = 'Pos/Neg Bar Graph Test'
    plot.labels = {
      0 => '5/6',
      1 => '5/15',
      2 => '5/24',
      3 => '5/30'
    }
    plot.data(:apples, [-1, -0, -4, -4])
    plot.data(:peaches, [-10, -8, -6, -3])

    plot.write('spec/reference_images/bar_neg_plot_test_test.png')
  end

  it 'tests min max ranges' do
    # This plot has a preset minimum and maximum range for the y axis.
    plot = Rubyplot::Bar.new
    plot.title = 'Nearly Zero Graph'
    plot.labels = {
      0 => '5/6',
      1 => '5/15',
      2 => '5/24',
      3 => '5/30'
    }
    plot.data(:apples, [1, 2, 3, 4])
    plot.data(:peaches, [4, 3, 2, 1])

    plot.minimum_value = 0
    plot.maximum_value = 10

    plot.write('spec/reference_images/bar_nearly_zero_max_10_test.png')
  end

  it 'tests legend overlap of a bar graph' do
    # This test has too many legends and some of those have too much text.
    # With this test we want to show that having too many legends is not an issue
    # and the legends self adjust in the plot.
    plot = Rubyplot::Bar.new(400)
    plot.title = 'My Graph'
    plot.data('Apples Oranges Watermelon Apples Oranges', [1, 2, 3, 4, 4, 3])
    plot.data('Oranges', [4, 8, 7, 9, 8, 9])
    plot.data('Watermelon', [2, 3, 1, 5, 6, 8])
    plot.data('Peaches', [9, 9, 10, 8, 7, 9])
    plot.labels = { 0 => '2003', 2 => '2004', 4 => '2005' }

    plot.write('spec/reference_images/bar_long_legend_test.png')
  end
end
