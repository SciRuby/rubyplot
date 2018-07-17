describe 'Stacked Area' do
  before do
    @datasets = [
      [:Delhi, [25, 36, 86, 39]],
      [:Kanpur, [80, 54, 67, 54]],
      [:Mumbai, [22, 29, 35, 38]]
    ]
    @labels = {
      0 => '5/6',
      1 => '5/15',
      2 => '5/24'
    }
  end

  it 'creates a Stacked Area graph' do
    plot = Rubyplot::StackedArea.new
    plot.title = 'Visual Stacked Area Graph Test'
    plot.labels = {
      0 => '5/6',
      1 => '5/15',
      2 => '5/24',
      3 => '5/30'
    }
    @datasets.each do |data|
      plot.data(data[0], data[1])
    end
    plot.write('spec/reference_images/stacked_area_test_1.png')
  end

  it 'Tests Many random datapoints' do
    plot = Rubyplot::StackedArea.new
    plot.title = 'Visual Stacked Area Graph Test'
    plot.labels = {
      0 => '5/6',
      1 => '5/15',
      2 => '5/24',
      3 => '5/30'
    }
    @datasets.each do |data|
      plot.data(data[0], data[1])
    end
    plot.colors = %i[red blue green white]
    plot.write('spec/reference_images/stacked_area_test_2.png')

    expect(compare_with_reference?('stacked_area_test_1.png', 'stacked_area_test_2.png', 10)).to eq(false)
  end
end
