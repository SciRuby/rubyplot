# Scatter plot using the bare-bones GR C interface
require_relative '../../lib/grruby.so'

x1 = [-10, 0, 5, 28]
y1 = [1, 2, 3, 4]
x2 = [2, 4, 16]
y2 = [10, 20, -40]
Rubyplot::GR.setviewport(0, 0.5, 0, 0.5)
Rubyplot::GR.setwindow(-100, 100, -100, 100)
Rubyplot::GR.axes(1, 1, -100, -100, 10, 10, 0.01)
Rubyplot::GR.polyline(x1,y1)
Rubyplot::GR.setviewport(0.5, 1, 0.5, 1)
Rubyplot::GR.setwindow(-100, 100, -100, 100)
Rubyplot::GR.axes(1, 1, 0, 0, 10, 10, 0.01)
Rubyplot::GR.polymarker(x2,y2)
Rubyplot::GR.updatews()
puts("done")
hold=gets

