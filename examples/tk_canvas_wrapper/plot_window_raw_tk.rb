# Minimal method to show a window with the figure using raw Tk
#
def plot_window(root = false)
  figure = Rubyplot::Artist::Figure.new(height: 20, width: 20)

  window = root ?
             TkRoot.new { title "Plot Demo" } :
             TkToplevel.new { title "Plot Demo" }
  content = Tk::Tile::Frame.new(window).grid(sticky: 'nsew', column: 1, row: 1)
  TkGrid.columnconfigure window, 1, weight: 1
  TkGrid.rowconfigure window, 1, weight: 1
  canvas = TkCanvas.new(content) { width 600; height 600 }
  canvas.grid sticky: 'nwes', column: 1, row: 1
  refresh_button = Tk::Tile::Button.new(content) do
    text "Refresh!"
    command { Tk.update; figure.show(canvas) }
  end.grid(column: 1, row: 2, sticky: 'es')
  TkGrid.columnconfigure content, 1, weight: 1
  TkGrid.rowconfigure content, 1, weight: 1
  TkGrid.rowconfigure content, 2, weight: 0

  yield figure

  Tk.update
  figure.show(canvas)
end
