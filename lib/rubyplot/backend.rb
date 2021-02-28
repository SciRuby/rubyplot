require_relative 'backend/base'
if ENV["RUBYPLOT_BACKEND"] == "GR"
  require_relative 'backend/gr_wrapper'
elsif ENV["RUBYPLOT_BACKEND"] == "TK_CANVAS"
  require_relative 'backend/tk_canvas_wrapper'
elsif ENV["RUBYPLOT_BACKEND"] = "MAGICK"
  require_relative 'backend/magick_wrapper'
end


