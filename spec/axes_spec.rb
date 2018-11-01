require 'spec_helper'
["magick"].each do |b|
  ENV['RUBYPLOT_BACKEND'] = b
  
  describe "Rubyplot::Axes b: #{Rubyplot.backend}." do
    context "#line!" do
      
    end

    context "#bar!" do
      before do
        @temp_dir = SPEC_ROOT + "temp/bar"
        @fix_dir = SPEC_ROOT + "fixtures/bar"
        FileUtils.mkdir_p @temp_dir
      end

      after do
        #        FileUtils.rm_rf SPEC_ROOT + "temp/bar"
      end

      it "adds a simple bar plot" do
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        axes.bar!(600) do |p| 
          p.marker_count = 8
          p.data [5,12,9,6,7]
          p.label = "data"
          p.color = :yellow
        end
        axes.title = "Random bar numbers"

        file = "/#{Rubyplot.backend}_simple_bar.png"
        fig.write(@temp_dir + file)

        expect(@temp_dir + file).to eq_image(@fix_dir + file)
      end

      it "adds bar plot with title margin" do
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        axes.bar!(600) do |p|
          p.marker_count = 8
          p.data [5,12,9,6,6]
          p.label = "data"
          p.color = :green
        end
        axes.title = "Bar with title margin = 100"
        axes.title_margin = 100

        file = "/#{Rubyplot.backend}_title_margin_bar.png"
        fig.write(@temp_dir + file)

        expect(@temp_dir + file).to eq_image(@fix_dir + file)
      end

      it "checks if Geometry adjusts for large numbers" do
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        axes.bar!(600) do |p|
          p.marker_count = 8
          p.data [7025, 1024, 40_257, 933_672, 1_560_496]
          p.label = "data"
        end
        axes.title = "Large numbers"

        file = "/#{Rubyplot.backend}_large_geometry.png"
        fig.write(@temp_dir + file)

        expect(@temp_dir + file).to eq_image(@fix_dir + file)
      end

      it "adds axes with X-Y labels" do
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        axes.bar!(800) do |p|
          p.data [40,50,60,80]
          p.label = "students"
        end
        axes.title = "Plot with X-Y axes."
        axes.x_title = "Score (%)"
        axes.y_title = "Students"
        axes.labels = {
          0 => '5/6',
          1 => '5/15',
          2 => '5/24',
          3 => '5/36'
        } 

        file = "/#{Rubyplot.backend}_set_x_y_label.png"
        fig.write(@temp_dir + file)

        expect(@temp_dir + file).to eq_image(@fix_dir + file)
      end

      it "adds multiple bar plots for wide graph" do
        data = [
          ["Moon", [25, 36, 86, 39]],
          ["Sun", [80, 54, 67, 54]],
          ["Earth", [22, 29, 35, 38]],
          ["Mars", [95, 95, 95, 90, 85, 80, 88, 100]],
          ["Venus", [90, 34, 23, 12, 78, 89, 98, 88]]
        ]
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        data.each do |name, nums|
          axes.bar!("800x400") do |p| 
            p.data nums
            p.label = name
          end
        end
        
        file = "/#{Rubyplot.backend}_wide_multiple_bars.png"
        fig.write(@temp_dir + file)

        expect(@temp_dir + file).to eq_image(@fix_dir + file)
      end

      it "plots both positive and negative values" do
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        axes.bar! do |p|
          p.data [-1, 0, 4, -4]
          p.label = "apples"
        end
        axes.bar! do |p|
          p.data [10,8,6,3]
          p.label = "peaches"
        end
        axes.title = "Pos/neg bar graph test."
        axes.labels = {
          0 => '5/6',
          1 => '5/15',
          2 => '5/24',
          3 => '5/30'
        }

        file = "/#{Rubyplot.backend}_pos_neg_bar_plots.png"
        fig.write(@temp_dir + file)

        expect(@temp_dir + file).to eq_image(@fix_dir + file)
      end

      it "tests negative values" do
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        axes.title = "all negative bar graph."
        axes.labels = {
          0 => '5/6',
          1 => '5/15',
          2 => '5/24',
          3 => '5/30'
        }
        axes.bar! do |p|
          p.data [-1,-5,-4,-4]
          p.label = "apples"
        end
        axes.bar! do |p|
          p.data [-10,-8,-6,-3]
          p.label = "peaches"
        end

        file = "/#{Rubyplot.backend}_all_neg_plots.png"
        fig.write(@temp_dir + file)

        expect(@temp_dir + file).to eq_image(@fix_dir + file)
      end

      it "sets min-max range for Y axis" do
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        axes.title = "nearly zero graph."
        axes.y_range [0,10]
        [
          [[1,2,3,4], "apples"],
          [[4,3,2,1], "peaches"]
        ].each do |nums, name|
          axes.bar! do |p|
            p.data nums
            p.label = name
          end
        end
        axes.labels = {
          0 => '5/6',
          1 => '5/15',
          2 => '5/24',
          3 => '5/30'
        }
        
        file = "/#{Rubyplot.backend}_y_axis_min_max_range.png"
        fig.write(@temp_dir + file)

        expect(@temp_dir + file).to eq_image(@fix_dir + file)
      end

      it "adjust legends if there are too many" do
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        axes.title = "My graph."
        [
          [[1, 2, 3, 4, 4, 3], 'Apples oranges Watermelon'],
          [[4, 8, 7, 9, 8, 9], "Oranges"]
          [[2, 3, 1, 5, 6, 8], "Watermelon"]
          [[9, 9, 10, 8, 7, 9], "Peaches"]
        ].each do |d, name|
          axes.bar! do |p|
            p.data d
            p.label = name
          end
        end
        axes.labels = { 0 => '2003', 2 => '2004', 4 => '2005' }

        file = "/#{Rubyplot.backend}_adjust_legens.png"
        fig.write(@temp_dir + file)

        expect(@temp_dir + file).to eq_image(@fix_dir + file)
      end
    end

    context "#scatter!", focus: true do
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
        axes.x_title = "X data"
        axes.y_title = "Y data"

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

        fig.write(SPEC_ROOT + "temp/scatter/#{Rubyplot.backend}_scatter_green.png")

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


