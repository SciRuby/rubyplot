require 'spec_helper'

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
    it "plots multiple stacked bar graphs with default colors" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
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
      axes.title = "Income."
      axes.x_title = "X title"
      axes.y_title = "Y title"
      axes.x_ticks = ['Jan', 'Feb', 'March', 'April', 'May', 'June',  'July',
                      'August', 'September', 'October', 'November', 'December']
      axes.y_ticks = ['5', '10', '15', '20', '25', '30']
    end

    it "plots stacked bar in a small size" do
      @figure = Rubyplot::Figure.new(height: 400, width: 400)
      axes = @figure.add_subplot! 0,0
      [
        ["Car", [25, 36, 86, 39]],
        ["Bus", [80, 54, 67, 54]],
        ["Train", [22, 29, 35, 38]]
      ].each do |label, data|
        axes.stacked_bar! do |p| 
          p.data data
          p.label = label
        end
      end
      axes.title = "stacked bar."
    end
  end

  context "#dot!" do
    skip "plots a single dot plot" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
      axes.dot! do |p|
        p.data [0,5,8,15]
        p.label = "Car"
        p.color = :maroon
      end
      axes.num_y_ticks = 4
      axes.y_ticks = ['5/6', '5/15', '5/24', '5/30']
    end

    skip "plots multiple dot plots" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
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
      axes.num_y_ticks = 4
      axes.y_ticks = ['5/6', '5/15', '5/24', '5/30']
    end
  end

  context "#bubble!" do
    it "plots a single bubble plot" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
      axes.bubble! do |p|
        p.data [-1, 19, -4, -23], [-35, 21, 23, -4], [4.5, 1.0, 2.1, 0.9]
        p.label = "apples"
        p.color = :blue
      end
      axes.x_range = [-40, 30]
      axes.y_range = [-40, 25]
      axes.title = "simple bubble plot."
    end

    it "plots multiple bubble plots on same axes." do 
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
      axes.bubble! do |p|
        p.data [-1, 19, -4, -23], [-35, 21, 23, -4], [4.5, 1.0, 2.1, 0.9]
        p.label = "apples"
      end
      axes.bubble! do |p|
        p.data [20, 30, -6, -3], [-1, 5, -27, -3], [10.3, 10.0, 20.0, 10.0]
        p.label = "peaches"
      end
      axes.title = "simple bubble plot."
    end
  end

  context "#area!" do
    it "plots a single simple Area graph" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
      axes.area! do |p|
        p.data [25, 36, 86, 39, 25, 31, 79, 88]
        p.label = "Jimmy"
      end
      axes.title = "Visual simple area graph test."
      axes.x_ticks = ['0', '22', '44', '66', '88']
    end

    it "plots multiple area plots on the same Axes" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
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
      axes.x_ticks = ['0', '2', '4', '6']
    end
  end
  
  context "#line!" do
    it "makes a simple line plot" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
      axes.line! do |p|
        p.data [2, 4, 7, 9], [1,2,3,4]
        p.label = "Marco"
        p.color = :blue
      end
      axes.title = "A line graph."
    end

    it "plots 2 simple lines on the same axes" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
      axes.line! do |p|
        p.data [3, 5, 10, 15]
        p.label = "Marco"
        p.color = :blue
      end
      axes.line! do |p|
        p.data [1, 9, 13, 28]
        p.label = "John"
        p.color = :green
      end
      axes.title = "A line graph."
    end

    it "tests very small plot" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
      axes.title = "very small line chart 200px"
      @planet_data.each do |name, d|
        axes.line! do |p|
          p.data d
          p.label = name
        end
      end
    end

    it "plots multiple 0 data" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
      axes.title = "hand value graph test"
      axes.line! do |p|
        p.data [0,0,100]
        p.label = "test"
      end
    end

    it "plots small values" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
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
    end

    it "plots line starting with 0" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
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
    end

    it "plots line with large values" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
      axes.title = "large values"
      [
        ["large", [100_005, 35_000, 28_000, 27_000]],
        ["large2", [35_000, 28_000, 27_000, 100_005]],
        ["large3", [28_000, 27_000, 100_005, 35_000]],
        ["large4", [1_238, 39_092, 27_938, 48_876]]
      ].each do |name, data|
        axes.line! do |p|
          p.line_width = 3
          p.data data
          p.label = name
        end
      end
    end

    it "accepts both X and Y data" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
      axes.title = "accept X and Y"
      axes.line! do |p|
        p.data [1, 3, 4, 5, 6, 10], [1, 2, 3, 4, 4, 3]
        p.label = "X"
      end
      axes.line! do |p|
        p.data [1, 3, 4, 5, 7, 9], [1, 1, 2, 2, 3, 3]
        p.label = "X1"
      end
    end
  end

  context "#bar!" do
    it "adds a simple bar plot" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
      axes.bar! do |p| 
        p.data [5,12,9,6,7]
        p.label = "data"
        p.color = :yellow
      end
      axes.x_ticks = ["five", "twelve", "nine", "six", "seven"]
      axes.title = "Random bar numbers"
    end

    it "adds bar plot with title margin" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
      axes.bar! do |p|
        p.data [5,12,9,6,6]
        p.label = "data"
        p.color = :green
      end
      axes.title = "Bar with title margin = 100"
      axes.title_font_size = 50.0
      axes.x_title = "Green data!"
      axes.y_title = "Green Y data!"
    end

    it "plots large numbers" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
      axes.bar! do |p|
        p.data [7025, 1024, 40_257, 933_672, 1_560_496]
        p.label = "data"
      end
      axes.title = "Large numbers"
    end

    it "adds axes with X-Y labels" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
      axes.bar! do |p|
        p.data [40,50,60,80]
        p.label = "students"
      end
      axes.title = "Plot with X-Y axes."
      axes.x_title = "Students"
      axes.y_title = "Score (%)"
      axes.x_ticks = [ '5/6', '5/15', '5/24', '5/36' ]
    end

    it "adds multiple bar plots for wide graph" do
      @figure = Rubyplot::Figure.new(height: 400, width: 800)
      axes = @figure.add_subplot! 0,0
      @planet_data.each do |name, nums|
        axes.bar! do |p| 
          p.data nums
          p.label = name
        end
      end
    end

    it "plots both positive and negative values" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
      axes.bar! do |p|
        p.data [-1, 0, 4, -4]
        p.label = "apples"
      end
      axes.bar! do |p|
        p.data [10,8,6,3]
        p.label = "peaches"
      end
      axes.title = "Pos/neg bar graph test."
      axes.x_ticks = ['5/6', '5/15', '5/24', '5/30']
    end

    it "tests negative values" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
      axes.title = "all negative bar graph."
      axes.x_ticks = ['5/6', '5/15', '5/24', '5/30']
      axes.bar! do |p|
        p.data [-1,-5,-4,-4]
        p.label = "apples"
      end
      axes.bar! do |p|
        p.data [-10,-8,-6,-3]
        p.label = "peaches"
      end
    end

    it "sets min-max range for Y axis" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
      axes.title = "nearly zero graph."
      axes.y_range = [0,10]
      [
        [[1,2,3,4], "apples"],
        [[4,3,2,1], "peaches"]
      ].each do |nums, name|
        axes.bar! do |p|
          p.data nums
          p.label = name
        end
      end
      axes.x_ticks = ['5/6', '5/15', '5/24','5/30']
    end

    it "adjust legends if there are too many" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
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
      axes.x_ticks = ['2003', '', '2004', '', '2005']
    end
  end

  context "#scatter!" do
    before do
      @x1 = [1, 2, 3, 4, 5]
      @y1 = [11, 2, 33, 4, 65]
    end
    
    it "adds a simple scatter plot." do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
      axes.scatter! do |p|
        p.data @x1, @y1
        p.label = "data1"
        p.color = :plum_purple
      end
      axes.title = "Nice plot"
      axes.x_title = "X data"
      axes.y_title = "Y data"
    end

    it "adds scatter with all negative values" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
      axes.scatter! do |p|
        p.data [-1, -1, -4, -4], [-5, -1, -3, -4]
        p.label = "apples"
      end
      axes.title = "all negative scatter graph test."
    end

    it "adds scatter with positive and negative values" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
      axes.scatter! do |p|
        p.data [-2,0,2,4,6], [-3,-1, 1, 4, 8]
        p.label = "values"
      end
      axes.title = "positive + negative test."
    end
  end

  context "#histogram!" do
    it "adds a single histogram with default bins" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
      axes.histogram! do |p| 
        p.x = 100.times.map{ rand(10) }
      end
    end

    it "adds a single histogram with custom bins" do
      skip "GR does not currently support custom tick marks."
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
      axes.histogram! do |p|
        p.x = 100.times.map{ rand(10) }
        p.bins = [1, 4, 7, 10]
      end
    end

    it "adds a single histogram with number of bins" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
      axes.histogram! do |p|
        p.x = 100.times.map{ rand(10) }
        p.bins = 5
      end
    end
  end

  context "#candle_stick!" do
    # FIXME: use data method to accept the data for the plot in one go.
    it "adds a simple candle stick plot" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
      axes.candle_stick! do |p|
        p.lows = [100, 110, 120, 130, 120, 110]
        p.highs = [140, 150, 160, 170, 160, 150]
        p.opens = [110, 120, 130, 140, 130, 120]
        p.closes = [130, 140, 150, 160, 150, 140]
      end
      axes.title = "Simple candle stick plot."
    end

    it "adds multiple candle stick plots" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0

      lows = [100, 110, 120, 130, 120, 110]
      highs = [140, 150, 160, 170, 160, 150]
      opens = [110, 120, 130, 140, 130, 120]
      closes = [130, 140, 150, 160, 150, 140]
      axes.candle_stick! do |p|
        p.lows = lows
        p.highs = highs
        p.opens = opens
        p.closes = closes
      end
      axes.candle_stick! do |p|
        p.lows = lows.map { |l| l + 100 }
        p.highs = highs.map { |h| h + 100 }
        p.opens = opens.map { |o| o + 100 }
        p.closes = closes.map { |c| c + 100 }
      end
      axes.candle_stick! do |p|
        p.lows = lows.map { |l| l + 10 }
        p.highs = highs.map { |h| h + 10 }
        p.opens = opens.map { |o| o + 10 }
        p.closes = closes.map { |c| c + 10 }
      end
      axes.title = "Multiple candle stick plot."
    end
  end

  context "#error_bar!" do
    before do
      @x = [1,2,3,4,5,6]
      @y = [3,4,5,6,7,8]
    end
    
    it "adds a simple xerr to error bar plot" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
      axes.title = "Simple error bar plot with xerr."
      axes.error_bar! do |p|
        p.x = @x
        p.y = @y
        p.xerr = 0.1
      end
    end

    it "adds a collection of xerr to the error bar plot" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
      axes.title = "Simple error bar plot with collection xerr."
      axes.error_bar! do |p|
        p.x = @x
        p.y = @y
        p.xerr = [0.1,0.3,0.5,0.1,0.2,0.4]
      end      
    end

    it "adds a simple xerr to the error bar plot" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
      axes.title = "Simple error bar plot with yerr."
      axes.error_bar! do |p|
        p.x = @x
        p.y = @y
        p.yerr = 0.1
      end
    end

    it "adds a collection of xerr to the error bar plot" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
      axes.title = "Simple error bar plot with collection yerr."
      axes.error_bar! do |p|
        p.x = @x
        p.y = @y
        p.yerr = [0.6,0.5,0.1,0.8,0.3,0.1]
      end      
    end

    it "adds both xerr and yerr to the error bar plot" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
      axes.title = "Simple error bar plot with collection xerr and yerr."
      axes.error_bar! do |p|
        p.x = [1,2,3,4]
        p.y = [1,4,9,16]
        p.xerr = [0.5,1.0,1.5,0.3]
        p.yerr = [0.6,0.2,0.8,0.1]
      end
    end
  end

  context "#box_plot!" do
    it "adds a simple box plot" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
      axes.title = "A simple box plot."
      axes.box_plot! do |p|
        p.data [
          [60,70,80,70,50],
          [100,40,20,80,70],
          [30, 10]
        ]
      end
      axes.x_title = "foo"
      axes.y_title = "bar"
    end
  end

  context "#top_margin=" do
    it "sets the top margin in pixels" do
      
    end
  end

  context "#left_margin=" do
    it "sets the left margin in pixels" do
      
    end
  end

  context "#bottom_margin=" do
    it "sets the bottom margin in pixels" do
      
    end
  end

  context "#right_margin=" do
    it "sets the right margin in pixels" do
      
    end
  end

  context "#x_ticks=" do
    it "assigns strings to X ticks" do
      @figure = Rubyplot::Figure.new
      axes = @figure.add_subplot! 0,0
      axes.scatter! do |p|
        p.data [1,2,3,4], [1,2,3,4]
        p.label = "apples"
      end
      axes.x_ticks = ["hello0", "hello1"]
    end
  end # context "#x_ticks="
end # Rubyplot::Axes

