require 'spec_helper'
["magick"].each do |b|
  ENV['RUBYPLOT_BACKEND'] = b
  
  describe "Rubyplot::Axes b: #{Rubyplot.backend}." do
    before do
      @planet_data = [
        ["Moon", [25, 36, 86, 39]],
        ["Sun", [80, 54, 67, 54]],
        ["Earth", [22, 29, 35, 38]],
        ["Mars", [95, 95, 95, 90, 85, 80, 88, 100]],
        ["Venus", [90, 34, 23, 12, 78, 89, 98, 88]]
      ]
    end

    context "#stacked_bar!" do
      before do 
        @temp_dir = SPEC_ROOT + "temp/stacked_bar"
        @fix_dir = SPEC_ROOT + "fixtures/stacked_bar"
        FileUtils.mkdir_p @temp_dir
      end

      it "plots a single stacked bar graph with default colors" do
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        axes.stacked_bar! do |p|
          p.data [25, 36, 86, 39]
          p.label = "moon"
        end
        axes.title = "net earnings in different months."
        axes.x_ticks = {
          0 => 'Jan',
          1 => 'Feb',
          2 => 'March',
          3 => 'April',
          4 => 'May',
          5 => 'June',
          6 => 'July',
          7 => 'August',
          8 => 'September',
          9 => 'October',
          10 => 'November',
          11 => 'December'
        }
        
        file = "/#{Rubyplot.backend}_simple_stacked_bar.png"
        fig.write(@temp_dir + file)

        #expect("temp/stacked_bar" + file).to eq_image("fixtures/stacked_bar" + file)
      end

      it "plots multiple stacked bar graphs with default colors" do
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        [
          ["Charles", [20, 10, 5, 12, 11, 6, 10, 7]],
          ["Adam", [5, 10, 20, 6, 9, 12, 14, 8]],
          ["Daniel", [19, 9, 6, 11, 12, 7, 15, 8]]
        ].each do |label, data|
          axes.stacked_bar! do |p|
            p.data data
            p.label = label
          end          
        end
        axes.title = "net earnings in different months."
        axes.x_ticks = {
          0 => 'Jan',
          1 => 'Feb',
          2 => 'March',
          3 => 'April',
          4 => 'May',
          5 => 'June',
          6 => 'July',
          7 => 'August',
          8 => 'September',
          9 => 'October',
          10 => 'November',
          11 => 'December'
        }
        
        file = "/#{Rubyplot.backend}_multiple_stacked_bar.png"
        fig.write(@temp_dir + file)

        #expect("temp/stacked_bar" + file).to eq_image("fixtures/stacked_bar" + file)
      end

      it "plots stacked bar in a small size" do
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        [
          ["Car", [25, 36, 86, 39]],
          ["Bus", [80, 54, 67, 54]],
          ["Train", [22, 29, 35, 38]]
        ].each do |label, data|
          axes.stacked_bar!(400) do |p| 
            p.data data
            p.label = label
          end
        end
        axes.title = "stacked bar."
        
        file = "/#{Rubyplot.backend}_small_stacked_bar.png"
        fig.write(@temp_dir + file)

        #expect("temp/stacked_bar" + file).to eq_image("fixtures/stacked_bar" + file)        
      end
    end

    context "#dot!" do
      before do 
        @temp_dir = SPEC_ROOT + "temp/dot"
        @fix_dir = SPEC_ROOT + "fixtures/dot"
        FileUtils.mkdir_p @temp_dir
      end

      it "plots a single dot plot" do
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        axes.dot! do |p|
          p.data [0,5,8,15]
          p.label = "Car"
          p.color = :maroon
          p.minimum_value = 0 # FIXME: change this!
        end
        axes.y_ticks = {
          0 => '5/6',
          1 => '5/15',
          2 => '5/24',
          3 => '5/30'
        }

        file = "/#{Rubyplot.backend}_simple_dot.png"
        fig.write(@temp_dir + file)

        #expect("temp/dot" + file).to eq_image("fixtures/dot" + file)
      end

      it "plots multiple dot plots" do
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        [
         [[0, 5, 8, 15], "cars", :maroon],
         [[10, 3, 2, 8], "buses", :grey],
         [[2, 15, 8, 11],"science", :yellow]
        ].each do |data, label, color|
          axes.dot! do |p|
            p.data data
            p.label = label
            p.color = color
            p.minimum_value = 0
          end
        end
        axes.y_ticks = {
          0 => '5/6',
          1 => '5/15',
          2 => '5/24',
          3 => '5/30'
        }

        file = "/#{Rubyplot.backend}_multiple_dot.png"
        fig.write(@temp_dir + file)

        #expect("temp/dot" + file).to eq_image("fixtures/dot" + file)
      end
    end

    context "#bubble!" do
      before do 
        @temp_dir = SPEC_ROOT + "temp/bubble"
        @fix_dir = SPEC_ROOT + "fixtures/bubble"
        FileUtils.mkdir_p @temp_dir
      end

      it "plots a single bubble plot" do
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        axes.bubble! do |p|
          p.data [-1, 19, -4, -23], [-35, 21, 23, -4], [45, 10, 21, 9]
          p.label = "apples"
          p.color = :blue
        end
        axes.title = "simple bubble plot."
        
        file = "/#{Rubyplot.backend}_simple_bubble.png"
        fig.write(@temp_dir + file)

        #expect("temp/bubble" + file).to eq_image("fixtures/bubble" + file)
      end

      it "plots multiple bubble plots on same axes." do 
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        axes.bubble! do |p|
          p.data [-1, 19, -4, -23], [-35, 21, 23, -4], [45, 10, 21, 9]
          p.label = "apples"
        end
        axes.bubble! do |p|
          p.data [20, 30, -6, -3], [-1, 5, -27, -3], [13, 10, 20, 10]
          p.label = "peaches"
        end
        axes.title = "simple bubble plot."
        
        file = "/#{Rubyplot.backend}_multiple_bubble.png"
        fig.write(@temp_dir + file)

        #expect("temp/bubble" + file).to eq_image("fixtures/bubble" + file)       
      end
    end

    context "#area!" do
      before do 
        @temp_dir = SPEC_ROOT + "temp/area"
        @fix_dir = SPEC_ROOT + "fixtures/area"
        FileUtils.mkdir_p @temp_dir
      end

      it "plots a single simple Area graph" do
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        axes.area! do |p|
          p.data [25, 36, 86, 39, 25, 31, 79, 88]
          p.label = "Jimmy"
        end
        axes.title = "Visual simple area graph test."
        axes.x_ticks = {
          0 => '0',
          2 => '2',
          4 => '4',
          6 => '6'
        }

        file = "/#{Rubyplot.backend}_simple_area.png"
        fig.write(@temp_dir + file)

        #expect("temp/area" + file).to eq_image("fixtures/area" + file)
      end

      it "plots multiple area plots on the same Axes" do
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        [
          ["Jimmy", [25, 36, 86, 39, 25, 31, 79, 88]],
          ["Charles", [80, 54, 67, 54, 68, 70, 90, 95]],
          ["Julie", [22, 29, 35, 38, 36, 40, 46, 57]],
          ["Jane", [3, 95, 95, 90, 85, 80, 88, 100]]
        ].each do |n, data|
          axes.area! do |p|
            p.data data
            p.label = n
          end
        end
        axes.title = "Multiple area plots on same axes."
        axes.x_ticks = {
          0 => '0',
          2 => '2',
          4 => '4',
          6 => '6'
        }

        file = "/#{Rubyplot.backend}_multiple_area.png"
        fig.write(@temp_dir + file)

        #expect("temp/area" + file).to eq_image("fixtures/area" + file)
      end
    end
    
    context "#line!" do
      before do 
        @temp_dir = SPEC_ROOT + "temp/line"
        @fix_dir = SPEC_ROOT + "fixtures/line"
        FileUtils.mkdir_p @temp_dir
      end

      after do
        
      end
      
      it "makes a simple line plot", focus: true do
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        axes.line! do |p|
          p.data [2, 4, 7, 9], [1,2,3,4]
          p.label = "Marco"
          p.color = :blue
        end
        axes.title = "A line graph."

        file = "/#{Rubyplot.backend}_simple_line.png"
        fig.write(@temp_dir + file)

        #expect("temp/line" + file).to eq_image("fixtures/line" + file)    
      end

      it "plots 2 simple lines on the same axes" do
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        axes.line! do |p|
          p.data [20, 23, 19, 8]
          p.label = "Marco"
          p.color = :blue
        end
        axes.line! do |p|
          p.data [1, 53, 76, 18]
          p.label = "John"
          p.color = :green
        end
        axes.title = "A line graph."
        axes.x_ticks = {
          0 => "Ola Ruby",
          1 => "Hello Ruby"
        }

        file = "/#{Rubyplot.backend}_simple_line.png"
        fig.write(@temp_dir + file)

        #expect("temp/line" + file).to eq_image("fixtures/line" + file)
      end

      skip "fails to match the reference image" do
        
      end

      it "tests very small plot" do
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        axes.title = "very small line chart 200px"
        @planet_data.each do |name, d|
          axes.line! do |p|
            p.data d
            p.label = name
          end
        end
 
        file = "/#{Rubyplot.backend}_very_small_plot.png"
        fig.write(@temp_dir + file)

        #expect("temp/line" + file).to eq_image("fixtures/line" + file)
      end

      it "plots multiple 0 data" do
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        axes.title = "hand value graph test"
        axes.line! do |p|
          p.data [0,0,100]
          p.label = "test"
        end

        file = "/#{Rubyplot.backend}_hang_value_test.png"
        fig.write(@temp_dir + file)

        #expect("temp/line" + file).to eq_image("fixtures/line" + file)
      end

      it "plots small values" do
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        axes.title = "small values"
        [
          [[0.1, 0.14356, 0.0, 0.5674839, 0.456], "small"],
          [[0.2, 0.3, 0.1, 0.05, 0.9], "small2"]
        ].each do |d, label|
          axes.line! do |p|
            p.data d
            p.label = label
          end
        end
        
        file = "/#{Rubyplot.backend}_small_values.png"
        fig.write(@temp_dir + file)

        #expect("temp/line" + file).to eq_image("fixtures/line" + file)
      end

      it "plots line starting with 0" do
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        axes.title = "starting with 0"
        [
          [[0, 5, 10, 8, 18], "first0"],
          [[1, 2, 3, 4, 5], "normal"]
        ].each do |data, name|
          axes.line! do |p|
            p.data data
            p.label = name
          end
        end

        file = "/#{Rubyplot.backend}_start_with_0.png"
        fig.write(@temp_dir + file)

        #expect("temp/line" + file).to eq_image("fixtures/line" + file)
      end

      it "plots line with large values" do
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        axes.title = "large values"
        axes.baseline_value = 50_000

        [
          ["large", [100_005, 35_000, 28_000, 27_000]],
          ["large2", [35_000, 28_000, 27_000, 100_005]],
          ["large3", [28_000, 27_000, 100_005, 35_000]],
          ["large4", [1_238, 39_092, 27_938, 48_876]]
        ].each do |name, data|
          axes.line! do |p|
            p.dot_radius = 15
            p.line_width = 3
            p.data data
            p.label = name
          end
        end
        
        file = "/#{Rubyplot.backend}_large_values.png"
        fig.write(@temp_dir + file)

        #expect("temp/line" + file).to eq_image("fixtures/line" + file)
      end

      it "accepts both X and Y data" do
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        axes.title = "accept X and Y"
        axes.line! do |p|
          p.data [1, 3, 4, 5, 6, 10], [1, 2, 3, 4, 4, 3]
          p.label = "X"
        end
        axes.line! do |p|
          p.data [1, 3, 4, 5, 7, 9], [1, 1, 2, 2, 3, 3]
          p.label = "X1"
        end
                
        file = "/#{Rubyplot.backend}_plot_x_y.png"
        fig.write(@temp_dir + file)

        #expect("temp/line" + file).to eq_image("fixtures/line" + file)
      end
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

      it "adds a simple bar plot", focus: true do
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        axes.bar!(600) do |p| 
          p.data [5,12,9,6,7]
          p.label = "data"
          p.color = :yellow
        end
        axes.title = "Random bar numbers"

        file = "/#{Rubyplot.backend}_simple_bar.png"
        fig.write(@temp_dir + file)

        #expect("temp/bar" + file).to eq_image("fixtures/bar" + file)
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

        # expect(@temp_dir + file).to eq_image(@fix_dir + file)
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

        # expect(@temp_dir + file).to eq_image(@fix_dir + file)
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
        axes.x_ticks = {
          0 => '5/6',
          1 => '5/15',
          2 => '5/24',
          3 => '5/36'
        } 

        file = "/#{Rubyplot.backend}_set_x_y_label.png"
        fig.write(@temp_dir + file)

        # expect(@temp_dir + file).to eq_image(@fix_dir + file)
      end

      it "adds multiple bar plots for wide graph", focus: true do
        fig = Rubyplot::Figure.new(height: 400, width: 800)
        axes = fig.add_subplot 0,0
        @planet_data.each do |name, nums|
          axes.bar! do |p| 
            p.data nums
            p.label = name
          end
        end
        
        file = "/#{Rubyplot.backend}_wide_multiple_bars.png"
        fig.write(@temp_dir + file)

        # expect(@temp_dir + file).to eq_image(@fix_dir + file)
      end

      skip "plots both positive and negative values" do
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
        axes.x_ticks = {
          0 => '5/6',
          1 => '5/15',
          2 => '5/24',
          3 => '5/30'
        }

        file = "/#{Rubyplot.backend}_pos_neg_bar_plots.png"
        fig.write(@temp_dir + file)

        expect(@temp_dir + file).to eq_image(@fix_dir + file)
      end

      skip "tests negative values" do
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        axes.title = "all negative bar graph."
        axes.x_ticks = {
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

      skip "sets min-max range for Y axis" do
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
        axes.x_ticks = {
          0 => '5/6',
          1 => '5/15',
          2 => '5/24',
          3 => '5/30'
        }
        
        file = "/#{Rubyplot.backend}_y_axis_min_max_range.png"
        fig.write(@temp_dir + file)

        expect(@temp_dir + file).to eq_image(@fix_dir + file)
      end

      skip "adjust legends if there are too many" do
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        axes.title = "My graph."
        [
          [[1, 2, 3, 4, 4, 3], 'Apples oranges Watermelon'],
          [[4, 8, 7, 9, 8, 9], "Oranges"],
          [[2, 3, 1, 5, 6, 8], "Watermelon"],
          [[9, 9, 10, 8, 7, 9], "Peaches"]
        ].each do |d, name|
          axes.bar! do |p|
            p.data d
            p.label = name
          end
        end
        axes.x_ticks = { 0 => '2003', 2 => '2004', 4 => '2005' }

        file = "/#{Rubyplot.backend}_adjust_legens.png"
        fig.write(@temp_dir + file)

        expect(@temp_dir + file).to eq_image(@fix_dir + file)
      end
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
        axes.scatter! do |p|
          p.data @x1, @y1
          p.label = "data1"
          p.color = :plum_purple
        end
        axes.title = "Nice plot"
        axes.x_title = "X data"
        axes.y_title = "Y data"

        fig.write(SPEC_ROOT + "temp/scatter/scatter.png")

        # expect("temp/scatter/scatter.png").to(
        #   eq_image("fixtures/scatter/scatter.png", 10))
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

      it "adds scatter with all negative values" do
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
    end # context "#scatter!"

    context "#x_ticks=" do
      it "assigns strings to X ticks" do
        fig = Rubyplot::Figure.new
        axes = fig.add_subplot 0,0
        axes.scatter! do |p|
          p.data [1,2,3,4], [1,2,3,4]
          p.label = "apples"
        end
        axes.x_ticks = {
          0 => "hello 0",
          1 => "hello 1"
        }
        fig.write SPEC_ROOT + "temp/scatter/x_ticks_string.png"
      end
    end # context "#x_ticks="
  end # Rubyplot::Axes
end # describe backends


