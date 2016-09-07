#!/bin/bash

set -e

if [ $# -ne 2 ]; then
    echo "Usage: $0 path/to/koa/man/adoc path/to/content/cli/reference"
    exit 1
fi

KOA_DIR="$1"
DOC_DIR="$2"

# Passed checks; proceeding with script
echo "Proceeding with script..."

# last updated date
DATE=$(date +"%B %d, %Y")
UPDATED=":revdate: ${DATE}"

# copying new files over
cp $DOC_DIR/index.adoc .
rm -r $DOC_DIR/*
cp -r $KOA_DIR/* $DOC_DIR/
rm -r $DOC_DIR/convert
rm $DOC_DIR/build.sh
mv ./index.adoc $DOC_DIR

# perform sed commands on all files
echo "Performing seds inline on files..."
#        sed -i '' 's/----/----terminal/' adoc/*.adoc
sed -i.bak -e 's/\*\([a-z]*\)\(([0-9])\)\*/link:..\/\1[\*\1\2\*]/g' $DOC_DIR/*.adoc

# update last updated date
# sed -i.bak -e "s/\:revdate: [^\s]+ [0-9]{1,2}, [0-9]{4}/${UPDATED}/g" $DOC_DIR/index.adoc
sed -i.bak -e "s/\:revdate:.*/${UPDATED}/g" $DOC_DIR/index.adoc

# update includes
sed -i.bak -e "s/include\:\:include/include\:\:content\/cli\/reference\/include/g" $DOC_DIR/*.adoc

echo "Seds complete..."

# reminder to update index page if necessary
echo "Don't forget to update the reference index page if needed!"

rm $DOC_DIR/*.adoc.bak