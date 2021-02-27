# rubyplot
An advanced plotting library for Ruby.

**Rubyplot aims to be the most advanced visualization solution for Rubyists.**

It aims to allow you to visualize anything, anywhere with a flexible, extensible, Ruby-like API.

# Backends

Rubyplot can use different backends to render its plots:

- `magick` Using ImageMagick
- `gr` Using the GR framework
- `tk_canvas` Interactive drawing in a Canvas object using Ruby/Tk

Call `Rubyplot.set_backend` at the start of your program to select
the desired backend.

Pick the desired one:

``` ruby
Rubyplot.set_backend(:magick)
Rubyplot.set_backend(:gr)
Rubyplot.set_backend(:tk_canvas)
```

# Installing GR

Install the GR framework from the [website](https://gr-framework.org/c.html).

Then set the `GRDIR` and `GKS_FONTPATH` ENV variables to point to your GR installation
and GR font path. Set the `RUBYPLOT_BACKEND` ENV variable to "GR". For example:
```
export GRDIR="/home/sameer/Downloads/gr"
export GKS_FONTPATH="/home/sameer/Downloads/gr"
export RUBYPLOT_BACKEND="GR"
```

# Installing Tk

In addition to install the `tk` gem in your project, you need to
install the Tcl/Tk runtime in your system. The instructions depending
on the OS but it is a safe bet to install the Community Edition of
Active Tcl from https://www.activestate.com/

You have more details about installing Tk in different systems in the
excelent [TkDocs](https://tkdocs.com/tutorial/install.html) website.

If you want to have a more modern way of interacting with Tk from
Ruby, you can use
[TkComponent](https://github.com/josepegea/tk_component) and
[TkInspect](https://github.com/josepegea/tk_inspect).

# Examples

See the [examples](./examples) to see some how-to code.

# Short term priorities

Check milestones in GitHub for more information.

# Long term vision
Rubyplot's long term vision, by priority:

* Integrate the Rubyplot interface with the GR framework.
* Generate various types of publication quality plots.
* Interactive plotting using QT/GTK.
* Integrate with bokehjs (or some other web framework) for plotting in the web browser.

# Release cycle

The library is currently in alpha stage. Version `0.1.0` is designated to be the
first 'final' release. Until then we will utilize various numbering schemes in the
third position of the version number to denote alpha, beta and RC releases. They
are as follows:

* `a` for `alpha`. For example `0.1-a1` is the first alpha release.
* `b` for `beta`. For example `0.1-b1` is the first beta release.
* `rc` for `RC`. For example `0.1-rc1` is the first RC release.
