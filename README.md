# rubyplot
An advanced plotting library for Ruby.

**Rubyplot aims to be the most advanced visualization solution for Rubyists.**

It aims to allow you to visualize anything, anywhere with a flexible, extensible, Ruby-like API.

# Usage

Install the GR framework from the [website](https://gr-framework.org/c.html).

Then set the `GRDIR` and `GKS_FONTPATH` ENV variables to point to your GR installation
and GR font path. Set the `RUBYPLOT_BACKEND` ENV variable to "GR". For example:
```
export GRDIR="/home/sameer/Downloads/gr"
export GKS_FONTPATH="/home/sameer/Downloads/gr"
export RUBYPLOT_BACKEND="GR"
```

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
