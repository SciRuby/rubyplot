require 'spec_helper'

RubyplotSpec.describe Rubyplot::Axes do
  context "#line!" do
    
  end

  context "#scatter!" do
    before do
      @x1 = [1, 2, 3, 4, 5]
      @y1 = [11, 2, 33, 4, 65]
      FileUtils.mkdir_p "spec/temp/scatter"
    end

    after do
      FileUtils.rm_rf "spec/temp/scatter"
    end
    
    it "adds a simple scatter plot.", focus: true do
      fig = Rubyplot::Figure.new
      axes = fig.add_subplot 0,0
      axes.scatter! do |p|
        p.data @x1, @y1
        p.label = "data1"
        p.color = :plum_purple
      end

      fig.write("spec/temp/scatter/scatter.png")

      expect("temp/scatter/scatter.png").to(
        eq_image("fixtures/scatter/scatter.png"))
    end

    it "adds a green cross scatter plot." do
      fig = Rubyplot::Figure.new
      axes = fig.add_subplot 1,1,1
      axes.scatter! do |p|
        p.data @x1, @y1
        p.color = :green
        p.size = 2
        p.type = :diagonal_cross
      end
    end
  end
end
