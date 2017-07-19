#!/bin/bash
set -e

# go to the repo root
cd "$(dirname "$0")/.."

asciidoc_bindir="$1"
bundle_bindir="$2"
if [ -z "$asciidoc_bindir" ];
then
    asciidoc_bindir=".build_tools/install/bin"
fi
if [ -z "$bundle_bindir" ];
then
    bundle_bindir=".build_tools/bundle-vendor/bin"
fi
export PATH="$bundle_bindir:$asciidoc_bindir:$PATH"

# check for RVMRC
# assume that any existing .rvmrc is valid and source it
if [ -f .rvmrc ];
then
    # ensure that RVM is loaded as a shell function (otherwise this gets
    # *really* murky and ugly)
    source "$HOME/.rvm/scripts/rvm"
    # run the rvmrc file, with rvm loaded as a function this should work fine
    source .rvmrc
fi

# Build latest
echo "Compiling site with nanoc"
rm -rf output
nanoc
