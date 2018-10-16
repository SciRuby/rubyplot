# Methods that involve additions/overloading to the draw class in Rmagick
module Magick
  class Draw
    # Method to Scale text annotation in RMagick
    def scale_annotation(img, width, height, x, y, text, scale)
      scaled_width = (width * scale) >= 1 ? (width * scale) : 1
      scaled_height = (height * scale) >= 1 ? (height * scale) : 1
      annotate(img, scaled_width.to_i, scaled_height.to_i, (x * scale).to_i, (y * scale).to_i, text.gsub('%', '%%'))
    end
  end
end
