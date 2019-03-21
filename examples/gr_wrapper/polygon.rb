# Filled polygon GR example.

require_relative '../../lib/grruby.so'

Rubyplot::GR.beginprint("polygon.png")
Rubyplot::GR.setviewport(0,1,0,1)
Rubyplot::GR.setwindow(0,100,0,100)
Rubyplot::GR.setfillintstyle(1)
Rubyplot::GR.settransparency(0.5)
Rubyplot::GR.fillarea([1, 5, 25, 30, 50, 30], [1, 5, 25, 30, 25, 5])
Rubyplot::GR.endprint
