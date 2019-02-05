# Scatter plot using the bare-bones GR C interface
require_relative '../../lib/grruby.so'

# x1 = [-10, 0, 5, 28]
# y1 = [1, 2, 3, 4]
# x2 = [2, 4, 16]
# y2 = [10, 20, -40]

Rubyplot::GR.clearws
Rubyplot::GR.setviewport(0.05, 0.95, 0.05, 0.95)
Rubyplot::GR.setwindow(0, 5, 0, 100)
#Rubyplot::GR.polymarker(x2,y2)
Rubyplot::GR.axes(0.2, 10, 0, 0, 2, 2, 0.01)
Rubyplot::GR.updatews
h = gets

