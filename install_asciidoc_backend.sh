#!/bin/bash
set -e

asciidoc --backend remove bootstrap
asciidoc --backend install asciidoc_bootstrap/bootstrap.zip

if [ $? -eq 0 ]; then
	echo "Asciidoc Bootstrap Backend installed"
else
	echo "Asciidoc Bootstrap Backend failed to installed"
	exit 1
fi