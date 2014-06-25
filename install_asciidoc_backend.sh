#!/bin/bash
set -e

asciidoc --backend install asciidoc_bootstrap/bootstrap.zip

if [ $? -eq 0 ] 
	echo "bootstrap installed"
fi