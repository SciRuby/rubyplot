#!/usr/bin/env ruby

# Shows several figures, each in its own window, using Tk
# Figures are extracted from other examples

require "bundler/setup"

ENV["RUBYPLOT_BACKEND"] = "TK_CANVAS"

require "rubyplot"

# Code to create a window and draw the figure inside
# Uncomment only one of the lines below
#
# - The first uses just raw Tk
#
# - The second uses TkComponent. For that, you'll have to include the
#   'tk_component' gem into your project

require_relative "./plot_window_raw_tk"
# require_relative "./plot_window_tk_component"

Rubyplot.set_backend(:tk_canvas)

# Here come the examples, extracted directly from the Tutorial

plot_window(true) do |figure|
  axes00 = figure.add_subplot! 0,0
  axes00.bar! do |p|
    p.data [23, 13, 45, 67, 5] # Data as given as heights of bars
    p.color = :neon_red # Colour of the bars
    p.spacing_ratio = 0.3 # Ratio of space the bars don't occupy out of the maximum space allotted to each bar
    # Each bar is allotted equal space, so maximum space for each bar is total space divided by the number of bars
    p.label = "Points"# Label for this data
  end

  axes00.title = "A bar plot"
  axes00.x_title = "X-axis"
  axes00.y_title = "Y-axis"
  axes00.square_axes = false
end

plot_window do |figure|
  axes = figure.add_subplot! 0,0
  [
    ["Charles", [20, 10, 5, 12, 11, 6, 10, 7], :silver],
    ["Adam", [5, 10, 20, 6, 9, 12, 14, 8], :black],
    ["Daniel", [19, 9, 6, 11, 12, 7, 15, 8], :orangeish]
  ].each do |label, data, color|
    axes.stacked_bar! do |p|
      p.data data
      p.label = label
      p.color = color
      p.spacing_ratio = 0.6
    end
  end
  axes.title = "Income."
  axes.x_title = "X title"
  axes.y_title = "Y title"
  axes.x_ticks = ['Jan', 'Feb', 'March', 'April', 'May', 'June',  'July',
                  'August', 'September', 'October', 'November', 'December']
  axes.y_ticks = ['5', '10', '15', '20', '25', '30']
end

plot_window do |figure|
  axes00 = figure.add_subplot! 0,0
  axes00.area! do |p|
    p.data [1, 2, 3, 4, 5, 6], [3, 2, 5, 5, 7, 4] # Data as height of consecutive points i.e. y coordinates
    p.color = :black # Color of the area
    p.label = "Stock A"# Label for this data
    p.stacked true # stacked option makes area plot opaque i.e. opacity = 1
    # Opacity of the area plot is set to 0.3 for visibility if not stacked
  end
  axes00.area! do |p|
    p.data [1, 2, 3, 4, 5, 6], [2, 1, 3, 4, 5, 1] # Data as height of consecutive points i.e. y coordinates
    p.color = :yellow # Color of the area
    p.label = "Stock B"# Label for this data
    p.stacked true # stacked option makes area plot opaque i.e. opacity = 1
    # Opacity of the area plot is set to 0.3 for visibility if not stacked
  end

  axes00.title = "An area plot"
  axes00.x_title = "Time"
  axes00.y_title = "Value"
  axes00.square_axes = false
end

plot_window do |figure|
  axes00 = figure.add_subplot! 0,0
  axes00.scatter! do |p|
    p.data [1, 2, 3, 4, 5],[12, 55, 4, 10, 24] # Data as arrays of x coordinates and y coordinates
    # i.e. the points are (1,12), (2,55), (3,4), (4,10), (5,24)
    p.marker_type = :diamond # Type of marker
    p.marker_fill_color = :lemon # Colour to be filled inside the marker
    p.marker_size = 2 # Size of the marker, unit is 15*pixels
    p.marker_border_color = :black # Colour of the border of the marker
    p.label = "Diamonds"# Label for this data
  end

  axes00.title = "A scatter plot"
  axes00.x_title = "X-axis"
  axes00.y_title = "Y-axis"
  axes00.square_axes = false
end

plot_window do |figure|
  axes00 = figure.add_subplot! 0,0
  axes00.bubble! do |p|
    p.data [12, 4, 25, 7, 19], [50, 30, 75, 12, 25], [0.5, 0.7, 0.4, 0.5, 1] # Data as arrays of x coordinates, y coordinates and sizes
    # Size units are 27.5*pixel
    p.color = :blue # Colour of the bubbles
    p.label = "Bubbles 1"# Label for this data
    # Opacity of the bubbles is set to 0.5 for visibility
  end
  axes00.bubble! do |p|
    p.data [1, 7, 20, 27, 17], [41, 30, 48, 22, 5], [0.5, 1, 0.8, 0.9, 1] # Data as arrays of x coordinates, y coordinates and sizes
    # Size units are 27.5*pixel
    p.color = :red # Colour of the bubbles
    p.label = "Bubbles 2"# Label for this data
    # Opacity of the bubbles is set to 0.5 for visibility
  end


  axes00.title = "A bubble plot"
  axes00.x_title = "X-axis"
  axes00.y_title = "Y-axis"
  axes00.square_axes = false
end

plot_window do |figure|
  axes00 = figure.add_subplot! 0,0
  axes00.histogram! do |p|
    p.data 100.times.map{ rand(10) } # Data as an array of values
    p.color = :electric_lime # Colour of the bars
    p.label = "Counts"# Label for this data
    # bins are not given so they are decided by Rubyplot
  end

  axes00.title = "A histogram"
  axes00.x_title = "X-axis"
  axes00.y_title = "Y-axis"
  axes00.square_axes = false
end

plot_window do |figure|
  axes00 = figure.add_subplot! 0,0
  axes00.candle_stick! do |p|
    p.lows = [100, 110, 120, 130, 120, 110] # Array for minimum values for sticks
    p.highs = [140, 150, 160, 170, 160, 150] # Array for maximum value for sticks
    p.opens = [110, 120, 130, 140, 130, 120] # Array for minimum value for bars
    p.closes = [130, 140, 150, 160, 150, 140] # Array for maximum value for bars
    p.border_color = :black # Colour of the border of the bars
    p.color = :yellow # Colour of the bars
    p.label = "Data"# Label for this data
  end

  axes00.title = "A candle-stick plot"
  axes00.x_title = "X-axis"
  axes00.y_title = "Y-axis"
  axes00.square_axes = false
end

plot_window do |figure|
  axes00 = figure.add_subplot! 0,0
  axes00.error_bar! do |p|
    p.data [1,2,3,4], [1,4,9,16] # Arrays for x coordinates and y coordinates
    p.xerr = [0.5,1.0,1.5,0.3] # X error for each point
    p.yerr = [0.6,0.2,0.8,0.1] # Y error for each point
    p.color = :red # Colour of the line
    p.label = "Values"# Label for this data
  end

  axes00.title = "An error-bar plot"
  axes00.x_title = "X-axis"
  axes00.y_title = "Y-axis"
  axes00.square_axes = false
end

plot_window do |figure|
  axes00 = figure.add_subplot! 0,0
  axes00.box_plot! do |p|
    p.data [
[60,70,80,70,50],
[100,40,20,80,70],
[30, 10]
] # Array of arrays for data for each box
    p.color = :blue # Colours of the boxes
    p.whiskers = 0.3 # whiskers for determining outliers
    p.outlier_marker_type = :hglass # Type of the outlier marker
    p.outlier_marker_color = :yellow # Fill colour of the outlier marker
    # Border colour of the outlier marker is set to black
    p.outlier_marker_size = 1 # Size of the outlier marker
    p.label = "Data"# Label for this data
  end

  axes00.title = "A box plot"
  axes00.x_title = "X-axis"
  axes00.y_title = "Y-axis"
  axes00.square_axes = false
end

plot_window do |figure|
  # Step 3
  axes00 = figure.add_subplot! 0,0
  axes00.bar! do |p|
    p.data [1, 2, 3, 4, 5] # Data as height of bars
    p.color = :lemon # Colour of the bars
    p.spacing_ratio = 0.2 # Ratio of space the bars don't occupy out of the maximum space allotted to each bar
    # Each bar is allotted equal space, so maximum space for each bar is total space divided by the number of bars
    p.label = "Stock 1"# Label for this data
  end
  # Spacing ratio declared first is considered
  axes00.bar! do |p|
    p.data [5, 4, 3, 2, 1] # Data as height of bars
    p.color = :blue # Colour of the bars
    p.spacing_ratio = 0.2 # Ratio of space the bars don't occupy out of the maximum space allotted to each bar
    # Each bar is allotted equal space, so maximum space for each bar is total space divided by the number of bars
    p.label = "Stock 2"# Label for this data
  end
  axes00.bar! do |p|
    p.data [3, 5, 7, 5, 3] # Data as height of bars
    p.color = :red # Colour of the bars
    p.spacing_ratio = 0.2 # Ratio of space the bars don't occupy out of the maximum space allotted to each bar
    # Each bar is allotted equal space, so maximum space for each bar is total space divided by the number of bars
    p.label = "Stock 3"# Label for this data
  end


  axes00.title = "A multi bar plot"
  axes00.x_title = "X-axis"
  axes00.y_title = "Y-axis"
  axes00.square_axes = false
end

plot_window do |figure|
  axes00 = figure.add_subplot! 0,0
  axes00.box_plot! do |p|
    p.data [
[60,70,80,70,50],
[100,40,20,80,70],
[30, 10]
] # Array of arrays for data for each box
    p.color = :lemon # Colours of the boxes
    p.whiskers = 0.3 # whiskers for determining outliers
    p.outlier_marker_type = :hglass # Type of the outlier marker
    p.outlier_marker_color = :yellow # Fill colour of the outlier marker
    # Border colour of the outlier marker is set to black
    p.outlier_marker_size = 1 # Size of the outlier marker
    p.label = "Data"# Label for this data
  end
  axes00.box_plot! do |p|
    p.data [
[10, 30, 90, 30, 20],
[120, 140, 150, 120, 75],
[70, 90]
] # Array of arrays for data for each box
    p.color = :red # Colours of the boxes
    p.whiskers = 0.1 # whiskers for determining outliers
    p.outlier_marker_type = :plus # Type of the outlier marker
    p.outlier_marker_color = :blue # Fill colour of the outlier marker
    # Border colour of the outlier marker is set to black
    p.outlier_marker_size = 1 # Size of the outlier marker
    p.label = "Data"# Label for this data
  end

  axes00.title = "A multi box plot"
  axes00.x_title = "X-axis"
  axes00.y_title = "Y-axis"
  axes00.square_axes = false
end

plot_window do |figure|
  axes00 = figure.add_subplot! 0,0
  axes00.plot! do |p|
    d = (0..360).step(5).to_a
    p.data d, d.map { |a| Math.sin(a * Math::PI / 180) } # Data as arrays of x coordinates and y coordinates
    p.marker_type = :circle # Type of marker
    p.marker_fill_color = :white # Colour to be filled inside the marker
    p.marker_size = 0.5 # Size of the marker, unit is 15*pixels
    p.marker_border_color = :black # Colour of the border of the marker
    p.line_type = :solid # Type of the line
    p.line_color = :black # Colour of the line
    p.line_width = 2 # Width of the line
    #   p.fmt = 'b.-' # fmt argument to specify line type, marker type and colour in short
    # fmt argument overwrites line type, marker type and all the colours i.e. marker_fill_color, marker_border_color, line_color
    # line type, marker type and colour can be in any order
    p.label = "sine" # Label for this data
  end

  axes00.title = "A plot function example"
  axes00.x_title = "X-axis"
  axes00.y_title = "Y-axis"
  axes00.square_axes = false
end

Tk.mainloop
