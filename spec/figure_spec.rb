require 'spec_helper'

describe Rubyplot::Figure do
  context "#add_subplot" do
    it "creates a singular subplot inside the Figure" do
      fig = Rubyplot::Figure.new
      axes = fig.add_subplot 0,0

      expect(axes).to be_a(Rubyplot::Axes)
    end
  end
end
