require 'rubyplot'
def random_dots
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

  plot.write('spec/reference_images/dot.png')
end

def setup_basic_dot_graph(size = 800)
  setup_data
  plot = Rubyplot::Dot.new(size)
  plot.title = 'My Dot Graph'
  plot.labels = {
    0 => '5/6'
  }
  @datasets.each do |data|
    plot.data(data[0], data[1])
  end
  plot
end
