# Scatter plot using the bare-bones GR C interface
require_relative '../../lib/grruby.so'

x1 = [-10, 0, 5, 28]
y1 = [1, 2, 3, 4]
x2 = [2, 4, 16]
y2 = [10, 20, -40]

print(Rubyplot::GR.version)
Rubyplot::GR.setviewport(0, 1, 0, 1)
Rubyplot::GR.setwindow(-110, 110, -110, 110)
Rubyplot::GR.polymarker(x2,y2)
#Rubyplot::GR.axes(1, 1, 0, 0, 10, 10, 0.01)
Rubyplot::GR.updatews
h = gets

