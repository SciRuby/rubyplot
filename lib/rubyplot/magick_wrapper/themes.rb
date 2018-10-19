module Rubyplot
  module MagickWrapper
    # This module is a set of constants to define themes constant variables
    # to be used with the RMagick code to make beautiful looking plots.
    module Themes
      # A color scheme similar to the popular presentation software.
      BASIC = {
        marker_color: 'white', # The color of the marker used to make marker lines on plot.
        font_color: 'white', # Font Color used to write on the plot.
        background_colors: %w[black #4a465a], # The Background colors that form the gradient
        label_colors:  %w[#ffe119 #0082c8 #f58231 #911eb4 #aaffc3 #808000 #ffd8b1 #000080 #808080]
      }.freeze

      TRACKS = {
        marker_color: 'white',
        font_color: 'white',
        background_colors: %w[#0083a3 #0083a3],
        label_colors: %w[yellow green blue red maroon grey \
#FF6A6A #FFAEB9 #EE82EE #00E5EE #00FF7F #C0FF3E #FFA500 #FFE4E1\
#BDBDBD #8B2500 #436EEE #DC143C]

      }.freeze

      OREO = {
        marker_color: 'white',
        font_color: 'white',
        background_colors: %w[#0083a3 #0083a3],
        label_colors: %w[#e6194b #3cb44b #ffe119 #0082c8 #f58231 #911eb4 #008080 #e6beff #aa6e28]
      }.freeze

      RITA = {
        marker_color: 'black',
        font_color: 'black',
        background_colors: %w[#d1edf5 white],
        label_colors: %w[#46f0f0 #f032e6 #d2f53c #fabebe #008080 #e6beff #aa6e28 #fffac8 #800000]
      }.freeze

      # Plain White back ground with no gradient.
      CLASSIC_WHITE = {
        marker_color: 'black',
        font_color: 'black',
        background_colors: %w[white white],
        label_colors: %w[#1f77b4 #ff7f0e #2ca02c #d62728 #9467bd #8c564b\
#e377c2 #7f7f7f #bcbd22 #17becf yellow maroon grey]
      }.freeze
    end
  end
end
