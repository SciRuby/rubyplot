require 'rubyplot'
def random_scatter
  plot = Rubyplot::Scatter.new(400)
  plot.data(:data1, [1, 2, 3, 4, 5], [11, 2, 33, 4, 65])
  plot.write('spec/reference_images/scatter.png')
end

def setup_basic_scatter(size = 800)
  setup_data
  plot = Rubyplot::Scatter.new(size)
  plot.title = 'Rad Graph'
  @datasets.each do |data|
    plot.data(data[0], data[1], data[2])
  end
  plot
end

def setup_pos_neg(size = 800)
  plot = Rubyplot::Scatter.new(size)
  plot.title = 'Pos/Neg Scatter Graph Test'
  plot.data(:apples, [-1, 0, 4, -4], [-5, -1, 3, 4])
  plot.data(:peaches, [10, 8, 6, 3], [-1, 1, 3, 3])
  plot
end

def setup_all_neg(size = 800)
  plot = Rubyplot::Scatter.new(size)
  plot.title = 'Neg Scatter Graph Test'
  plot.data(:apples, [-1, -1, -4, -4], [-5, -1, -3, -4])
  plot.data(:peaches, [-10, -8, -6, -3], [-1, -1, -3, -3])
  plot
end
