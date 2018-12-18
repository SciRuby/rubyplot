module Rubyplot
  # A set of constants to define themes constant variables
  # to be used to make beautiful looking plots.
  module Themes
    # A color scheme similar to the popular presentation software.
    BASIC = {
      marker_color: 'white', # The color of the marker used to make marker lines on plot.
      font_color: 'white', # Font Color used to write on the plot.
      background_colors: %I[black gun_powder], # The Background colors that form the gradient
      label_colors: %I[lemon bondi_blue sun dark_orchid magic_mint olive sandy_beach navy grey]
    }.freeze

    TRACKS = {
      marker_color: 'white',
      font_color: 'white',
      background_colors: %I[eastern_blue eastern_blue],
      label_colors: %I[yellow green blue red maroon grey \
bittersweet light_pink violet bright_turquoise spring_green green_yellow orange misty_rose\
silver falu_red royal_blue crimson]

    }.freeze

    OREO = {
      marker_color: 'white',
      font_color: 'white',
      background_colors: %I[eastern_blue eastern_blue],
      label_colors: %I[crimson fruit_salad lemon bondi_blue sun dark_orchid teal mauve hot_toddy]
    }.freeze

    RITA = {
      marker_color: 'black',
      font_color: 'black',
      background_colors: %I[pattens_blue white],
      label_colors: %I[turquoise razzle_dazzle_rose pear your_pink teal mauve hot_toddy lemon_chiffon maroon]
    }.freeze

    # Plain White back ground with no gradient.
    CLASSIC_WHITE = {
      marker_color: 'black',
      font_color: 'black',
      background_colors: %I[white white],
      label_colors: %I[strong_blue vivid_orange dark_lime_green strong_red slightly_desaturated_violet \
dark_grey strong_yellow strong_cyan yellow maroon grey]
    }.freeze
  end
end
