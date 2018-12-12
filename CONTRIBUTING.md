# Developer notes

## Co-ordinate system

Rubyplot assumes that the co-ordinate system has the origin at the top left corner
of the graph. This helps in keeping all pixel co-ordinates positive values.

Each Artist contains a `(abs_x, abs_y)` pair that denotes the absolute position of the 
Artist on the canvas. For `Figure` and `Axes` this pair denotes the top left corner.

The absolute co-ordinates are calculated during the draw phase. Therefore there 
should be no code except in the `draw` methods where actual co-ordinates are calcualted.

Varible naming conventions:
* All values that are absolute values will be prefixed with `abs_`.
* Variables relating to positioning of the graph other than the absolute
variables are always ratios.
