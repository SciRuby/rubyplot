# Rubyplot developer notes

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

## Axis objects

Since the parameters of the both Axis objects (`XAxis` and `YAxis`) can be modified
by almost any element in the plot (like changing tick labels, positioning, origin, etc.)
a convention to follow is that a constituent object of the Axis should be modified
and the corresponding object be placed in the Axis object, which will handle its drawing.

# GR extension notes

## setwindow and setviewport

The `Rubyplot::GR.setwindow` function allows setting up 'world co-ordinates' that are
basically as a point of reference for future activities like setting up axes and 
plotting points. For example, if you call the `setwindow` function as like this:
``` ruby
Rubyplot::GR.setwindow(0,100,0,100)
```
GR will set the lower left corner of the 'world' to `(0,0)` and the upper left corner
to `(100,100)`. So when you use the `GR.axes()` function to setup co-ordinate axes
you will only see the 0th quadrant of the co-ordinate space.

In order to change the position of this 'world' on the canvas, it is necessary to use
the `setviewport` function. Imagine this function as the zoom function of a camera. You
can use to either 'zoom out' fully and see everything that is front of you, or you can
'zoom in' to a particular area and see only that. Your zoom level determines your 'world'.

The only difference is that in case of viewports there is no actual zooming in but only
demarcation of areas within the canvas that are to treated as the 'world'.

The implication on rubyplot would be that an `Axes` within a `Figure` would get mapped
to a `viewport` and the plotting within the viewport would take place by setting up the
world co-ordinates to between the X and Y range.

