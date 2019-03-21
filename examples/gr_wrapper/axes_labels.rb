# Custom labels for axes.

require_relative '../../lib/grruby.so'

# ndc_x - NDC X co-ordinate.
# ndc_y - NDC Y co-ordinate.
# svalue - internal string represenation of the label.
# value - floating point representation of label drawn at x,y.
x_axis_proc = Proc.new { |ndc_x, ndc_y, svalue, value|
  Rubyplot::GR.text(ndc_x, ndc_y, "hello")
}

y_axis_proc = Proc.new { |ndc_x, ndc_y, svalue, value|
  Rubyplot::GR.text(ndc_x, ndc_y, "world")
}

Rubyplot::GR.beginprint("rect.png")
Rubyplot::GR.setviewport(0.1, 0.9, 0.1, 0.9)
#Rubyplot::GR.setwindow(0,100,0,100)
Rubyplot::GR.axeslbl(0.2, 10, 0, 0, 2, 2, 0.01, x_axis_proc, y_axis_proc)
Rubyplot::GR.drawrect(0.01, 0.9, 0.3, 0.8)
Rubyplot::GR.endprint

