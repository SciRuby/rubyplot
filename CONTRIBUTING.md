# Developer notes

## Co-ordinate system

Rubyplot assumes that the co-ordinate system has the origin at the bottom left corner
of the graph. This helps in keeping all pixel co-ordinates positive values. The bottom
left corner is `(0,0)` and the upper left corner is `(100,100)`. The backend should be
accomodated to work with this system. They are also denoted as `(Rubyplot::MIN_X, Rubyplot::MIN_X)`
and `(Rubyplot::MAX_X, Rubyplot::MAX_Y)`.

The only time where actual pixel values are used is when specifying the width/height
of the `Figure` or when actually plotting things using the backend.

The co-ordinates are always specified by proportions otherwise. The proportions are
always specified w.r.t the full canvas.

Each artist contains `abs_x` and `abs_y` variables that hold the values between 0 and 1
that specify its position on the canvas.

However font sizes and things that we don't have control over are still specified in pixels.
Here's the list of things that are still written in pixels:
+ All font sizes.

## Drawing flow

When the `draw` method in `Axes` is called, the call sequence is as follows:
* Determine X and Y ranges.
* Normalize the data within these ranges.
* Assign defaults (if not assigned by user):
  - Default label colors.
* Consolidate plots like bar plots into 'Multi-' plots.
* Figure out location of the Axes title.
* Figure out location of the legends.

## Test infrastructure

Since it is quite tough to generate the exact same plot with the exact same
pixels on all systems, we perform automated testing by running the same
plotting code twice, saving the generated files of each run in separate files
then comparing them both pixel by pixel.

To make this as smooth as possible, we use the `RSpec.configure` method to define
an `after(:example)` block which will run each example twice, save the image generated
by each run to a separate file and then compare both the files.

The `after(:example)` block requires a `@figure` instance variable which it will use
for performing the plotting. A check will be performed for the `@figure` instance
variable before the example is run.

## Artist defaults convention

Due to nature of a viz library, each Artist tends to have many instance variables
for storing various kinds of information about the Artist.
