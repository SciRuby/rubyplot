require 'spec_helper'
describe 'Scatter' do
  it 'Make a scatter plot of a graph' do
    random_scatter
    plot = Rubyplot::Scatter.new(400)
    plot.data(:data1, [1, 2, 3, 4, 5], [11, 2, 33, 4, 65])
    plot.write('spec/reference_images/scatterplot_testplot_1.png')

    expect(compare_with_reference?('scatter.png', 'scatterplot_testplot_1.png', 10)).to eq(true)
  end

  it 'Fails to match with the reference image' do
    random_scatter
    plot = Rubyplot::Scatter.new(400)
    plot.data(:data1, [1, 2, 3, 4, 5], [11, 2, 33, 4, 66])
    plot.write('spec/reference_images/scatterplot_testplot_2.png')

    expect(compare_with_reference?('scatter.png', 'scatterplot_testplot_2.png', 10)).to eq(false)
  end

  it 'Tests Many random datapoints' do
    plot = Rubyplot::Scatter.new
    plot.title = 'Many Datapoint Graph Test'
    y_values = (0..50).map { rand(100) }
    x_values = (0..50).map { rand(100) }
    plot.data('many points', x_values, y_values)

    # Default theme
    plot.write('spec/reference_images/scatter_many_test.png')
  end

  # Done
  it 'Test No Title' do
    plot = Rubyplot::Scatter.new(400)
    plot.data(:data1, [1, 2, 3, 4, 5], [1, 2, 3, 4, 5])

    plot.write('spec/reference_images/scatter_no_title_test.png')
  end

  # Done
  it 'Test Positive and Negative Values' do
    plot = setup_pos_neg(800)
    plot.write('spec/reference_images/scatter_pos_neplot_test.png')

    plot = setup_pos_neg(400)
    plot.title = 'Pos/Neg Line Test Small'
    plot.write('spec/reference_images/scatter_pos_neg_400_test.png')
  end

  # Done
  it 'Test All Negative Values' do
    plot = setup_all_neg(800)
    plot.write('spec/reference_images/scatter_all_neplot_test.png')

    plot = setup_all_neg(400)
    plot.title = 'All Neg Line Test Small'
    plot.write('spec/reference_images/scatter_all_neg_400_test.png')
  end
end
