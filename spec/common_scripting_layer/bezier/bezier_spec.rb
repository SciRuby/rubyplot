describe :Bezier do
  it 'creates a Bezier graph' do
    # Just make a very simple plot that just makes a series plot
    plot = Rubyplot::Bezier.new
    plot.data(:series_numbers, [-1, 10, 24, 39])
    plot.write('spec/reference_images/bezier-test-1.png')

    expect(compare_with_reference?('bezier.png', 'bezier-test-1.png', 10)).to eq(true)
  end

  it 'colors the Bezier draw area inside the Plot' do
    # Just make a very simple plot that just makes a series plot
    plot = Rubyplot::Bezier.new
    plot.data(:series_numbers, [-1, 10, 24, 39])
    plot.color = :red # A few strings will be preset to map to the real color values
    plot.write('spec/reference_images/bezier-test-2.png')

    expect(compare_with_reference?('bezier.png', 'bezier-test-2.png', 10)).to eq(false)
    # The two curves have different color of the bezier so the equaliy check fails.
  end
end
