# Create a plot showing multiple subplots and some random lines across them.
x = [1,2,3,4,5]
y = [10,20,30,40,50]

fig = Rubyplot::Figure.new
axes = fig.add_subplot 0,0
axes.scatter! do |p|
  p.data x, y
  p.label = "data1"
  p.color = :plum_purple
end
