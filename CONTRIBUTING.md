# Rubyplot developer notes

## Co-ordinate system

Rubyplot assumes that the co-ordinate system has the origin at the bottom left corner
of the graph. This helps in keeping all pixel co-ordinates positive values. The bottom
left corner is `(Rubyplot.min_x, Rubyplot.min_x)` and the upper left corner is 
`(Rubyplot::max_x, Rubyplot.max_y)`. The backend should be accomodated to work with 
this system. They are also denoted as and . This system is known as the 
`Rubyplot Artist Co-ordinates` system internally within the codebase.

The only time where actual pixel valus are used is when specifying the width/height
of the `Figure` or when actually plotting things using the backend.

The co-ordinates are always specified by proportions otherwise. The proportions are
always specified w.r.t the full canvas.

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

## Units and measurements

It is important to read up on units and measurements as used in a computer system if you
want to contribute to rubyplot. Here's some suggested reading:
* Point (unit) - https://en.wikipedia.org/wiki/Point_(typography)

# GR extension notes

## Typography

The most common way of specifying font sizes is by using the 'point' unit. This is what rubyplot
uses at a top level. However, the backend can work with some different units, which makes it
important to translate points to the right unit.

### Font sizes in GR

The only way to tell GR to change the way a font looks is by changing the font height,
spacing etc. using the `settextfontprec`, `settextcolorind`, `setcharheight`, `setcharup`,
and other such functions.

All these features are abstracted using `Rubyplot::Artist::Text`, which accepts inputs
in human-understadable format and uses the appropriate GR primitives to do its job.

## Figure sizes

GR does not allow changing the internal DPI setting as of now (which is 600).
The size of the figure can be set using the `setwsviewport` or `setwswindow` functions.
Therefore, `setwsviewport(0, 6 * 0.0254, 0, 3 * 0.0254)` would create a 6 by 3
inch image at 600 dpi.

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

The implication on rubyplot would be that an `Axes` within a `Figure` would get mappped
to a `viewport` and the plotting within the viewport would take place by setting up the
world co-ordinates to between the X and Y range.

## GR binaries

You can download the GR binaries for your system from [here](https://gr-framework.org/c.html#installation).

GR uses certain environment variables for working with fonts and searching the GR shared
object binary. These variables must be set before you use the GR backend of rubyplot. 
They are:

### GRDIR
Directory to which GR is installed. Should contain files in the standard structure. Example:
```
export GRDIR="/home/sameer/gr"
```

### GKS\_WSTYPE
Type of output that you wish from the workspace. Set to `png` for PNG output.
Example:
```
export GKS_WSTYPE=png
```

### GKS\_FILEPATH
Name of output file in case of wanting to write to file.
```
export GKS_FILEPATH="hello.png"
```
