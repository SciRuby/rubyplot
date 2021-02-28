# Minimal method to show a window with the figure using TkComponent
require "tk_component"

class PlotComponent < TkComponent::Base
  attr_accessor :chart

  def initialize(options = {})
    super
    @chart = options[:chart]
  end

  def render(p, parent_component)
    p.vframe(sticky: 'wens', x_flex: 1, y_flex: 1) do |vf|
      @canvas = vf.canvas(sticky: 'wens', width: 600, height: 600, x_flex: 1, y_flex: 1)
      vf.button(text: "Redraw", sticky: 'e', on_click: ->(e) { chart.show(@canvas.native_item) })
    end
  end

  def component_did_build
    Tk.update
    chart.show(@canvas.native_item)
  end
end

def plot_window(root = false)
  window = TkComponent::Window.new(title: "Plot Demo", root: root)
  figure = Rubyplot::Artist::Figure.new(height: 20, width: 20)

  yield figure

  component = PlotComponent.new(chart: figure)
  window.place_root_component(component)
end
