#!/bin/bash
set -e

# go to the repo root
cd "$(dirname "$0")/.."

asciidoc_bindir="$1"
if [ -z "$asciidoc_bindir" ];
then
    asciidoc_bindir=".build_tools/install/bin"
fi
export PATH="$asciidoc_bindir:$PATH"

echo "Installing asciidoc backend with asciidoc_bindir=$asciidoc_bindir"

(cd asciidoc/backends/bootstrap; zip -r bootstrap.zip . -x ".*" -x "*/.*")

if [ -d ~/.asciidoc/backends/bootstrap ]; then
	echo "Removing Asccidoc Bootstrap Backend"
	asciidoc --backend remove bootstrap
fi

echo "Installing Asccidoc Bootstrap Backend"
asciidoc --backend install asciidoc/backends/bootstrap/bootstrap.zip

if [ $? -eq 0 ]; then
	echo "Asciidoc Bootstrap Backend installed"
else
	echo "Asciidoc Bootstrap Backend failed to installed"
	exit 1
fi
