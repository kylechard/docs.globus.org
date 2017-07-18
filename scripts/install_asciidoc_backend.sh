#!/bin/bash
set -e

# go to the repo root
cd "$(dirname "$0")/.."

install_dir="$1"
if [ -z "$install_dir" ];
then
    install_dir=".build_tools/install"
fi
export PATH="$install_dir/bin:$PATH"

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
