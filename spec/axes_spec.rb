require 'spec_helper'
["magick"].each do |b|
  ENV['RUBYPLOT_BACKEND'] = b
  
  describe "Rubyplot::Axes b: #{Rubyplot.backend}." do
    context "#line!" do
      
    end

    context "#scatter!" do
      before do
        @x1 = [1, 2, 3, 4, 5]
        @y1 = [11, 2, 33, 4, 65]
        FileUtils.mkdir_p SPEC_ROOT + "temp/scatter"
      end

      after do
#        FileUtils.rm_rf SPEC_ROOT + "temp/scatter"
      end

      it "adds a simple scatter plot." do
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        axes.scatter!(400) do |p|
          p.data @x1, @y1
          p.label = "data1"
          p.color = :plum_purple
        end

        fig.write(SPEC_ROOT + "temp/scatter/scatter.png")

        expect("temp/scatter/scatter.png").to(
          eq_image("fixtures/scatter/scatter.png", 10))
      end

      it "adds a green cross scatter plot." do
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        axes.scatter!(400) do |p|
          p.data @x1, @y1
          p.color = :green
          p.marker_size = 2
          p.marker_type = :diagonal_cross
        end

        fig.write(SPEC_ROOT + "temp/scatter/scatter_green.png")

        # expect("temp/scatter/scatter_green.png").to(
        #   eq_image("fixtures/scatter/scatter_green.png", 10))
      end

      it "adds scatter with all negative values", focus: true do
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        axes.scatter!(400) do |p|
          p.data [-1, -1, -4, -4], [-5, -1, -3, -4]
          p.label = "apples"
        end
        axes.title = "all negative scatter graph test."

        fig.write(SPEC_ROOT + "temp/scatter/scatter_all_neg.png")
      end

      it "adds multiple scatter plots" do
        
      end
    end
  end
end


