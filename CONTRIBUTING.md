# Developer notes

## Co-ordinate system

Rubyplot assumes that the co-ordinate system has the origin at the top left corner
of the graph. This helps in keeping all pixel co-ordinates positive values.

Each Artist contains a `(abs_x, abs_y)` pair that denotes the absolute position of the 
Artist on the canvas. For `Figure` and `Axes` this pair denotes the top left corner.

The absolute co-ordinates are calculated during the draw phase. Therefore there 
should be no code except in the `draw` methods where actual co-ordinates are calcualted.

Varible naming conventions:
* All values that are absolute values will be prefixed with `abs_**.
* Variables relating to positioning of the graph other than the absolute
variables are always ratios.

## Drawing flow

When the `draw` method in `Axes` is called, the call sequence is as follows:
* Determine X and Y ranges.
* Normalize the data within these ranges.
* Assign defaults (if not assigned by user):
  - Default label colors.
* Consolidate plots like bar plots into 'Multi-' plots.
* Figure out location of the Axes title.
* Figure out location of the legends.
