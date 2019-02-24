# Scatter plot using the bare-bones GR C interface
require_relative '../../lib/grruby.so'

Rubyplot::GR.beginprint("rect.png")
Rubyplot::GR.setviewport(0, 1, 0, 1)
#Rubyplot::GR.setwindow(0,100,0,100)
Rubyplot::GR.axes(0.2, 10, 0, 0, 2, 2, 0.01)
Rubyplot::GR.drawrect(0.01, 0.9, 0.3, 0.8)
Rubyplot::GR.endprint
