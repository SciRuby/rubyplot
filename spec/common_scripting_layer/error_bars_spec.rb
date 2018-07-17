describe 'Error Bars!' do
  before do
    @open = [10, 15, 24, 18]
    @high = [20, 25, 30, 18]
    @low = [5, 13, 15, 3]
    @close = [15, 24, 18, 4]
  end

  it 'Creates an error bars plot' do
    plot = Rubyplot::ErrorBars.new
    plot.data(@open, @high, @low, @close)
    plot.write('spec/reference_images/error_bars_test_1.png')

    expect(compare_with_reference?('error_bars.png', \
                                   'error_bars_test_1.png', 10)).to eq(true)
  end

  it 'creates a candle plot with blue positive and black negative color' do
    plot = Rubyplot::ErrorBars.new
    plot.data(@open, @high, @low, @close)
    plot.up_color = :blue
    plot.down_color = :black
    plot.write('spec/reference_images/error_bars_test_2.png')

    expect(compare_with_reference?('error_bars.png', \
                                   'error_bars_test_2.png', 10)).to eq(false)
  end
end
