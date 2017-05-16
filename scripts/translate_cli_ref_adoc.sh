#!/bin/bash

set -e

if [ $# -ne 2 ]; then
    echo "Usage: $0 path/to/globus-cli path/to/content/cli"
    exit 1
fi

KOA_DIR="$1"
DOC_DIR="$2"
HOSTED_DIR="$2/hosted"

# Passed checks; proceeding with script
echo "Proceeding with script..."

# endpoint acivation
INDEX='---\
menu_weight: 10\
short_title: Reference\
---\
\
= /'

# last updated date
DATE=$(date +"%B %d, %Y")

# backup old hosted reference
mv $HOSTED_DIR .

# copying new files over
rm -r $DOC_DIR/reference/*
cp -r $KOA_DIR/* $DOC_DIR/reference/

# perform sed commands on all files
echo "Performing seds inline on files..."
#        sed -i '' 's/----/----terminal/' adoc/*.adoc
sed -i.bak -e 's/\*\([a-z]*\)\(([0-9])\)\*/link:..\/\1[\*\1\2\*]/g' $DOC_DIR/reference/*.adoc

# add menu_weight and title to index page
sed -i.bak -e "s/^\= /${INDEX}" $DOC_DIR/reference/index.adoc

#add last updated date
sed -i.bak -e "/\= Command Line Interface (CLI) Reference/a\\
:revdate: $DATE\\
\\
[doc-info]*Last Updated: {revdate}*
" $DOC_DIR/reference/index.adoc

# update includes
sed -i.bak -e "s/include\:\:include/include\:\:content\/cli\/reference\/include/g" $DOC_DIR/reference/*.adoc
sed -i.bak -e "s/include\:\:/include\:\:content\/cli\/reference\/include\//g" $DOC_DIR/reference/include/*.adoc
sed -i.bak -e "s/includeinclude/include/g" $DOC_DIR/reference/*.adoc

echo "Seds complete..."

# mv old hosted reference files back
mv ./hosted $DOC_DIR

# update includes in hosted dir
sed -i.bak -e "s/\/cli\/reference/\/cli\/hosted/g" $HOSTED_DIR/*.adoc

#remove bak files
rm $DOC_DIR/reference/*.adoc.bak
rm $DOC_DIR/reference/include/*.adoc.bak