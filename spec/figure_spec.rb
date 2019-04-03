require 'spec_helper'

describe Rubyplot::Figure do
  context ".new" do
    it "accepts figsize in centimeter (default)", focus: true do
      fig = Rubyplot::Figure.new(width: 30, height: 40)

      expect(fig.width).to eq(30)
      expect(fig.height).to eq(40)
      expect(fig.figsize_unit).to eq(:cm)
    end

    it "accepts figsize in pixels" do
      fig = Rubyplot::Figure.new(width: 200, height: 200, figsize_unit: :pixel)

      expect(fig.width).to eq(200)
      expect(fig.height).to eq(200)
      expect(fig.figsize_unit).to eq(:pixel)
    end

    it "accepts figsize in inches" do
      fig = Rubyplot::Figure.new(width: 3.0, height: 4.0, figsize_unit: :inch)

      expect(fig.width).to eq(3.0)
      expect(fig.height).to eq(4.0)
      expect(fig.figsize_unit).to eq(:inch)
    end

    it "accepts portrait orientation" do
      fig = Rubyplot::Figure.new(width: 4.0, height: 3.0, figsize_unit: :inch)

      expect(fig.width).to eq(4.0)
      expect(fig.height).to eq(3.0)
      expect(fig.figsize_unit).to eq(:inch)
    end

    it "changes Rubyplot Artist Co-ordinates as per aspect ratio." do
      fig = Rubyplot::Figure.new(width: 20, height: 20)

      expect(Rubyplot.max_x).to eq(100.0)
      expect(Rubyplot.max_y).to eq(100.0)

      fig = Rubyplot::Figure.new(width: 30, height: 20)
      
      expect(Rubyplot.max_x).to eq(150.0)
      expect(Rubyplot.max_y).to eq(100.0)

      fig = Rubyplot::Figure.new(width: 20, height: 30)
      
      expect(Rubyplot.max_x).to eq(100.0)
      expect(Rubyplot.max_y).to eq(150.0)
    end
  end
  
  context "#add_subplot!" do
    it "creates a singular subplot inside the Figure" do
      fig = Rubyplot::Figure.new
      axes = fig.add_subplot! 0,0

      expect(axes).to be_a(Rubyplot::Artist::Axes)
    end

    it "creates 2x1 subplots within a Figure" do
      @figure = Rubyplot::Figure.new
      @figure.add_subplots! 2, 1
      axes0 = @figure.add_subplot! 0,0
      axes1 = @figure.add_subplot! 1,0

      expect(axes0.abs_x).to eq(5.0)
      expect(axes0.abs_y).to eq(5.0)
      expect(axes0.width).to eq(90.0)
      expect(axes0.height).to eq(45.0)

      expect(axes1.abs_x).to eq(5.0)
      expect(axes1.abs_y).to eq(50.0)

      axes0.x_range = [0, 10]
      axes0.y_range = [0, 70]
      axes0.scatter! do |p|
        p.data [1, 2, 3, 4, 5], [11, 2, 33, 4, 65]
        p.label = "axes0"
      end

      axes1.bar! do |p|
        p.data [5,12,9,6,7]
        p.label = "axes1"
      end
    end

    it "creates 2x2 subplots with a Figure" do
      @figure = Rubyplot::Figure.new
      @figure.add_subplots! 2, 2
      axes0 = @figure.add_subplot! 0,0
      axes1 = @figure.add_subplot! 0,1
      axes2 = @figure.add_subplot! 1,0
      axes3 = @figure.add_subplot! 1,1

      axes0.candle_stick! do |p|
        p.lows = [100, 110, 120, 130, 120, 110]
        p.highs = [140, 150, 160, 170, 160, 150]
        p.opens = [110, 120, 130, 140, 130, 120]
        p.closes = [130, 140, 150, 160, 150, 140]
      end
      axes0.title = "Simple candle stick plot."

      lows = [100, 110, 120, 130, 120, 110]
      highs = [140, 150, 160, 170, 160, 150]
      opens = [110, 120, 130, 140, 130, 120]
      closes = [130, 140, 150, 160, 150, 140]
      axes1.candle_stick! do |p|
        p.lows = lows
        p.highs = highs
        p.opens = opens
        p.closes = closes
      end
      axes1.candle_stick! do |p|
        p.lows = lows.map { |l| l + 100 }
        p.highs = highs.map { |h| h + 100 }
        p.opens = opens.map { |o| o + 100 }
        p.closes = closes.map { |c| c + 100 }
      end
      axes1.candle_stick! do |p|
        p.lows = lows.map { |l| l + 10 }
        p.highs = highs.map { |h| h + 10 }
        p.opens = opens.map { |o| o + 10 }
        p.closes = closes.map { |c| c + 10 }
      end
      axes1.title = "Multiple candle stick plot."

      axes2.line! do |p|
        p.data [2, 4, 7, 9], [1,2,3,4]
        p.label = "Marco"
        p.color = :blue
      end
      axes2.title = "A line graph."

      axes3.bar! do |p|
        p.data [5,12,9,6,6]
        p.label = "data"
        p.color = :green
      end
      axes3.title = "Bar with title margin = 100"
    end
  end
end
