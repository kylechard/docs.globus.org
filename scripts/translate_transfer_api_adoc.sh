#!/bin/bash

set -e

if [ $# -ne 2 ]; then
    echo "Usage: $0 path/to/koa/doc/manual path/to/content/api/transfer"
    exit 1
fi

KOA_DIR="$1"
DOC_DIR="$2"

TOC='\:toc\:\
\:toclevels\: 3\
\:numbered\:'

# menu_weight vars

# overview
O='---\
menu_weight: 0\
---\
\
= /'
# endpoint acivation
EA='---\
menu_weight: 1\
---\
\
= /'
# task submission
TS='---\
menu_weight: 2\
---\
\
= /'
# task management
TASK='---\
menu_weight: 3\
---\
\
= /'
# file operations
FO='---\
menu_weight: 4\
---\
\
= /'
# endpoint management
EM='---\
menu_weight: 5\
---\
\
= /'
# endpoint search
ES='---\
menu_weight: 6\
---\
\
= /'
# endpoint roles
ER='---\
menu_weight: 7\
---\
\
= /'
# endpoint bookmarks
EB='---\
menu_weight: 8\
---\
\
= /'
# endpoint acl management
ACL='---\
menu_weight: 9\
---\
\
= /'
# advanced endpoint management
AEM='---\
menu_weight: 10\
---\
\
= /'
# changelog
CH='---\
menu_weight: 12\
---\
\
= /'

# last updated date
DATE=$(date +"%B %d, %Y")
UPDATED=":revdate: ${DATE}"
UPDATED2='\
\
[doc-info]*Last Updated: {revdate}*\
'

# copying new files over
cp -r $KOA_DIR/* $DOC_DIR/
rm $DOC_DIR/Makefile
rm $DOC_DIR/private_*
rm $DOC_DIR/README

echo "Performing seds inline on files..."

# (index page only) 
# Inter-document links require a "" prefix, and "" suffix.
sed -i.bak -e 's/link:\([_a-z0-9]*\){outfilesuffix}/link:\1/g' $DOC_DIR/index.adoc

# (all other pages)
# Inter-document links require a "../" prefix, and "" suffix.
sed -i.bak -e 's/link:\([_a-z0-9]*\){outfilesuffix}/link:..\/\1/g' $DOC_DIR/*.adoc

# Note that we don't have to mess with internal cross references 
# ( <<section,name>> syntax)

# Replace all table-of-contents macro(s)
sed -i.bak -e "s/^\:toc\: macro/${TOC}/g" $DOC_DIR/*.adoc
sed -i.bak -e "/^toc\:\:\[\]/d" $DOC_DIR/*.adoc

# This is for asciidoctor, not needed for asciidoc
sed -i.bak -e "/^\:compat-mode\:/d" $DOC_DIR/*.adoc

# Change history is an infinite list of headings, so don't number it
# TODO: Do we need TOC at all on change_history?
sed -i.bak -e 's/^\:numbered\://g' $DOC_DIR/change_history.adoc

# Add menu_weights
sed -i.bak -e "s/^\= /${ACL}" $DOC_DIR/acl.adoc
sed -i.bak -e "s/^\= /${AEM}" $DOC_DIR/advanced_endpoint_management.adoc
sed -i.bak -e "s/^\= /${CH}" $DOC_DIR/change_history.adoc
sed -i.bak -e "s/^\= /${EA}" $DOC_DIR/endpoint_activation.adoc
sed -i.bak -e "s/^\= /${EB}" $DOC_DIR/endpoint_bookmarks.adoc
sed -i.bak -e "s/^\= /${ER}" $DOC_DIR/endpoint_roles.adoc
sed -i.bak -e "s/^\= /${ES}" $DOC_DIR/endpoint_search.adoc
sed -i.bak -e "s/^\= /${EM}" $DOC_DIR/endpoint.adoc
sed -i.bak -e "s/^\= /${FO}" $DOC_DIR/file_operations.adoc
sed -i.bak -e "s/^\= /${O}" $DOC_DIR/overview.adoc
sed -i.bak -e "s/^\= /${TS}" $DOC_DIR/task_submit.adoc
sed -i.bak -e "s/^\= /${TASK}" $DOC_DIR/task.adoc

# (index page only) 
# Add last updated date
sed -i.bak -e "/\= Transfer API Documentation/a\\
:revdate: $DATE\\
\\
[doc-info]*Last Updated: {revdate}*
" $DOC_DIR/index.adoc

rm $DOC_DIR/*.adoc.bak
