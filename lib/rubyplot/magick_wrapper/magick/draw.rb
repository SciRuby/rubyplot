# Methods that involve additions/overloading to the draw class in Rmagick
module Magick
  class Draw
    # Method to Scale text annotation in RMagick

    # rubocop:disable Metrics/ParameterLists
    def scale_annotation(img, width, height, x_param, y_param, text, scale)
      scaled_width = (width * scale) >= 1 ? (width * scale) : 1
      scaled_height = (height * scale) >= 1 ? (height * scale) : 1
      annotate(img,
        scaled_width.to_i,
        scaled_height.to_i,
        (x_param * scale).to_i, (y_param * scale).to_i,
        text.gsub('%', '%%'))
    end
    # rubocop:enable Metrics/ParameterLists
  end
end
