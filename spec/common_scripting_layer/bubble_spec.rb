describe 'Bubble' do
  before do
    @bubble_data = [[12, 4, 53, 24],
                    [4, 34, 8, 25],
                    [20, 9, 31, 2],
                    [56, 12, 84, 30]]
  end

  it 'Creates a Bubble graph' do
    plot = Rubyplot::Bubble.new
    plot.data(:apples, [-1, -1, -4, -4], [-5, -1, -3, -4], [2, 4, 5, 1])
    plot.data(:peaches, [-10, -8, -6, -3], [-1, -1, -3, -3], [1, 4, 6, 1])
    plot.write('spec/reference_images/bubble_test_1.png')

    expect(compare_with_reference?('bubble.png', 'bubble_test_1.png', 10)).to eq(true)
  end

  it 'Tests Many random datapoints' do
    plot = Rubyplot::Bubble.new
    plot.title = 'Many Datapoint Graph Test'
    z_values = (0..50).map { rand(100) }
    y_values = (0..50).map { rand(100) }
    x_values = (0..50).map { rand(100) }
    plot.data('many points', x_values, y_values, z_values)

    # Default theme
    plot.write('spec/reference_images/bubble_many_tests.png')
  end
end
