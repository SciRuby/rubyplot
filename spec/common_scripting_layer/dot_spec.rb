require 'spec_helper'
describe 'Graph' do
  it 'Makes a dot plot of a graph' do
    random_dots
    plot = Rubyplot::Dot.new
    plot.labels = {
      0 => '5/6',
      1 => '5/15',
      2 => '5/24',
      3 => '5/30'
    }
    plot.data(:Cars, [0, 5, 8, 15])
    plot.data(:Bus, [10, 3, 2, 8])
    plot.data(:Science, [2, 15, 8, 11])

    plot.minimum_value = 0
    plot.write('spec/reference_images/dot_test_1.png')
    expect(compare_with_reference?('dot.png', 'dot_test_1.png', 10)).to eq(true)
  end

  it 'Fails to match with the reference image' do
    plot = Rubyplot::Dot.new
    plot.labels = {
      0 => '5/6',
      1 => '5/15',
      2 => '5/24'
    }
    plot.data(:Cars, [0, 5, 8, 15])
    plot.data(:Bus, [10, 3, 2, 8])
    plot.data(:Science, [2, 15, 8, 11])

    plot.minimum_value = 0
    plot.write('spec/reference_images/dot_test_2.png')
    expect(compare_with_reference?('dot.png', 'dot_test_2.png', 10)).to eq(false)
  end

  it 'Test titles' do
    plot = setup_basic_dot_graph(400)
    plot.title = 'Base Title'
    plot.write('spec/reference_images/dot_title_test.png')
  end

  it 'test_set_marker_count' do
    plot = setup_basic_dot_graph(400)
    plot.title = 'Set marker'
    plot.marker_count = 10
    plot.write('spec/reference_images/dot_set_marker_test.png')
  end

  it 'test_x_y_labels' do
    plot = setup_basic_dot_graph(400)
    plot.title = 'X Y Labels'
    plot.x_axis_label = 'Score (%)'
    plot.y_axis_label = 'Students'
    plot.write('spec/reference_images/dot_x_y_labels_test.png')
  end

  it 'test_wide_graph' do
    plot = setup_basic_dot_graph('800x400')
    plot.title = 'Wide Graph'
    plot.write('spec/reference_images/dot_wide_graph_test.png')

    plot = setup_basic_dot_graph('400x200')
    plot.title = 'Wide Graph Small'
    plot.write('spec/reference_images/dot_wide_graph_small_plot_test.png')
  end

  it 'test_tall_graph' do
    plot = setup_basic_dot_graph('400x600')
    plot.title = 'Tall Graph'
    plot.write('spec/reference_images/dot_tall_graph_test.png')

    plot = setup_basic_dot_graph('200x400')
    plot.title = 'Tall Graph Small'
    plot.write('spec/reference_images/dot_tall_graph_small_plot_test.png')
  end

  it 'test_negative' do
    plot = Rubyplot::Dot.new
    plot.title = 'Pos/Neg Dot Graph Test'
    plot.labels = {
      0 => '5/6'
    }
    plot.data(:apples, [-1, 0, 4, -4])
    plot.data(:peaches, [10, 8, 6, 3])

    plot.write('spec/reference_images/dot_pos_neplot_test.png')
  end

  it 'test_nearly_zero' do
    plot = Rubyplot::Dot.new
    plot.title = 'Nearly Zero Graph'
    plot.labels = {
      0 => '5/6'
    }
    plot.data(:apples, [1, 2, 3, 4])
    plot.data(:peaches, [4, 3, 2, 1])
    plot.minimum_value = 0
    plot.maximum_value = 10
    plot.write('spec/reference_images/dot_nearly_zero_max_10_test.png')
  end
end
