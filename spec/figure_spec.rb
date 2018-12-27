require 'spec_helper'

describe Rubyplot::Figure do
  context "#add_subplot" do
    it "creates a singular subplot inside the Figure" do
      fig = Rubyplot::Figure.new
      axes = fig.add_subplot 1,1,1

      expect(axes).to be_a(Rubyplot::Axes)
    end
  end

  context "#reset!" do
    it "resets all values to defaults" do
      fig = Rubyplot::Figure.new
      axes = fig.add_subplot 0,0
      axes.title = "reset test"
      fig.reset!

      expect(axes.title).to eq("")
    end
  end
end
