describe :Bubble do
  before do
    @bubble_data = [[12, 4, 53, 24],
                    [4, 34, 8, 25],
                    [20, 9, 31, 2],
                    [56, 12, 84, 30]]
  end
  # Reference -> https://help.plot.ly/excel/bubble-chart/

  it 'creates a bubble graph' do
    plot = Rubyplot::Bubble.new
    plot.data(:apples, [-1, -1, -4, -4], [-5, -1, -3, -4], [2, 4, 5, 1])
    plot.data(:peaches, [-10, -8, -6, -3], [-1, -1, -3, -3], [1, 4, 6, 1])
    plot.write('spec/reference_images/bubble_test_1.png')

    expect(compare_with_reference?('bubble.png', 'bubble_test_1.png', 10)).to eq(true)
  end

  it 'creates a bubble graph with different labels to test if the colors are visually separable.' do
    plot = Rubyplot::Bubble.new
    plot.data(:apples, [-1, -1, -4, -4], [-5, -1, -3, -4], [2, 4, 5, 1])
    plot.data(:peaches, [-10, -8, -6, -3], [-1, -1, -3, -3], [6, 4, 6, 7])
    plot.data(:oranges, [-10, 34, 16, 13], [33, 10, 7, 33], [6, 8, 7, 6])
    plot.data(:bananas, [11, 4, 26, 13], [0o5, 7, 23, 13], [4, 3, 2, 5])
    plot.write('spec/reference_images/bubble_test_1.png')

    expect(compare_with_reference?('bubble.png', 'bubble_test_1.png', 10)).to eq(true)
  end
end
