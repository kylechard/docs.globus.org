# Developer Setup Guide

These are the steps and information needed to run `nanoc` and other site
development tools.

## Requirements

Ruby >= 2.1.2 is required to build the site, and `bundler` is required to
install ruby packages.

You will also need Python 2.7, and `pip`, the python package manager, to do site
deployments.

This guide will cover setup with and without rvm -- this tool is optional, but
recommended.

## (Optional) Create RVM Gemset

If you do want to use RVM, these are the steps you'll need to set things up.

The deploy script is (vaguely) aware of the possibility that you could be
running an RVM environment.
We'll need to create an `rvmrc` file so that the deploy script can detect and
activate it.

Typically, the setup steps might be something like

```sh
rvm gemset create ruby@globus-docs
```

to create, and then

```sh
rvm use ruby@globus-docs
```

to activate.

If you want the deploy script to automatically activate the RVM environment,
you should additionally run

```sh
cat 'rvm use ruby@globus-docs' > .rvmrc
```

in the repository root.

## Setup Procedure

### Install asciidoc

For the general case, documentation on installation can be found
[on the asciidoc site](http://www.methods.co.nz/asciidoc/INSTALL.html), but the
instructions for Debian and Ubuntu are just

```sh
sudo apt-get install asciidoc
```

### Install AWS CLI

This is only needed to deploy the site -- it is not incorporated into site
builds and is therefore not necessary to do testing and development.

Just run

```sh
sudo pip install awscli
```

You could use a virtualenv, but the AWS CLI is generally fine to install
globally.

If you don't have `pip`, you might be able to use `easy_install` instead, as in

```sh
sudo easy_install awscli
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
