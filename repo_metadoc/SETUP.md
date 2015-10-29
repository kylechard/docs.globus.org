# Developer Setup Guide

These are the steps and information needed to run `nanoc` and other site
development tools.


## Requirements

Ruby >= 2.1.2 is required to build the site, and `bundler` is required to
install ruby packages.

You will also need Python 2.7, and `pip`, the python package manager.

This guide will cover setup with and without virtualenv and rvm -- these tools
are optional, but recommended.

## (Optional) Create Virtualenv & RVM Gemset

If you do want to use RVM and Virtualenv, these are the steps you'll need to
set things up.
Note that RVM and Virtualenv don't always play 100% nice together -- you can
set `rvm_silence_path_mismatch_check_flag=1` in your `~/.rvmrc` to handle some
of this, but general configuration of RVM and Virtualenv is beyond the scope of
this doc.

The deploy script is (vaguely) aware of the possibility that you could be
running a virtualenv and RVM environment.
We need to name the virtualenv correctly to ensure that the deploy script finds
it, and we'll need to describe any RVM environment we use with a very simple
rvmrc file.

Typically, the setup steps might be something like

```sh
rvm gemset create ruby@globus-docs
virtualenv .virtualenv # ensure that this runs in the repository root dir
```

to create, and then

```sh
rvm use ruby@globus-docs
source .virtualenv/bin/activate
```

to activate.

As long as the virtualenv is named `.virtualenv` the deploy script will find
it.
If you want the deploy script to automatically activate the RVM environment,
just run

```sh
cat 'rvm use ruby@globus-docs' > .rvmrc
```

in the repository root.

## Setup Procedure

### Install pygments

If you are not using a virtualenv, just run

```sh
sudo pip install pygments
```

and you're done!

If you are using virtualenv, you will want to install pygments into the
virtualenv.

To do this, simply run

```sh
source .virtualenv/bin/activate
pip install pygments
```

Be sure NOT to run this command with `sudo`.
You want to use the version of `pip` installed in your virtualenv, not the
system's global version of `pip`.

### Install asciidoc

For the general case, documentation on installation can be found
[on the asciidoc site](http://www.methods.co.nz/asciidoc/INSTALL.html), but the
instructions for Debian and Ubuntu are just

```sh
sudo apt-get install asciidoc
```

### Install Gems

Regardless of whether or not you use RVM, the command to install the
requisite gems is

```sh
bundle install
```

It is worth noting that a bad Gemfile.lock can cause this step to fail.
In such scenarios the simplest 95% effective resolution is to run

```sh
bundle update
```
