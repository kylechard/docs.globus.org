#!/bin/bash
set -e

# go to the repo root
cd "$(dirname "$0")/.."

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
