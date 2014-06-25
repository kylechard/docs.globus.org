#!/bin/bash
set -e

asciidoc --backend remove bootstrap
asciidoc --backend install asciidoc_bootstrap/bootstrap.zip

if [ $? -eq 0 ] 
	echo "Bootstrap installed"
fi