require 'spec_helper'

describe Rubyplot::Figure do
  context "#add_subplot!" do
    it "creates a singular subplot inside the Figure" do
      fig = Rubyplot::Figure.new
      axes = fig.add_subplot! 0,0

      expect(axes).to be_a(Rubyplot::Artist::Axes)
    end

    it "creates 2x1 subplots within a Figure", focus: true do
      @figure = Rubyplot::Figure.new
      @figure.add_subplots! 2, 1
      axes0 = @figure.add_subplot! 0,0
      axes1 = @figure.add_subplot! 1,0

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
    end
  end
end
