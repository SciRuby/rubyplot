require 'rubyplot'
# Makes a Bar graph with random graph numbers
def random_bar_graph
  base = Rubyplot::Bar.new(600)
  base.title = 'Random Bar Numbers'
  base.marker_count = 8
  base.data('data', [5, 12, 9, 6, 7])
  base.write('spec/reference_images/bar.png')
end

# Makes a bar graph with a preset title margin.
def bar_graph_with_title_margin
  plot = Rubyplot::Bar.new(600)
  plot.title = 'Random Bar Numbers'
  plot.marker_count = 8
  plot.data('data', [5, 12, 9, 6, 6])
  plot.title = 'Bar Graph with Title Margin = 100'
  plot.title_margin = 100
  plot.write('spec/reference_images/bar_title.png')
end

# Sets up basic bar graph
def setup_basic_bar_graph(size = 800)
  setup_data
  plot = Rubyplot::Bar.new(size)
  plot.title = 'My Bar Graph'
  plot.labels = {
    0 => '5/6',
    1 => '5/15',
    2 => '5/24',
    3 => '5/36'
  }
  @datasets.each do |data|
    plot.data(data[0], data[1])
  end
  plot
end
