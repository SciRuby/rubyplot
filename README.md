# rubyplot
An advanced plotting library for Ruby.

**Rubyplot aims to be the most advanced visualization solution for Rubyists.**

It aims to allow you to visualize anything, anywhere with a simple, Ruby-like API.

# Roadmap by priority
The release schedule and feature roadmap is as follows. Check issues labelled with
the version tags for knowing what we're working on currently. Listed by priority.

## Release v0.1-a1
Deadline: 15 January 2019

* Support currently available plots fully with various customization options on Axes.
* Fully automated testing infrastructure. Travis integration with rubocop.xs

## Release v0.1-a2
Deadline: 26 February 2019

* Integrate GR backend into existing API.
* Support multiple Axes on the same Figure. 
* Support atleast 3 new kinds of plots.

## Release v0.1-a3
Deadline: 15 April 2019

* Support atleast 3 new kinds of plots.
* Move from using Ruby Arrays to a typed-array based system.
* Support for iruby notebook (Jupyter).

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
