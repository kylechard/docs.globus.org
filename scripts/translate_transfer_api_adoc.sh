#!/bin/bash

set -e

if [ $# -ne 1 ]; then
    echo "Usage: $0 path/to/content/api/transfer"
    exit 1
fi

DOC_DIR="$1"

TOC='toc\:\
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

echo "Performing seds inline on files..."
sed -i.bak -e 's/----\n/----terminal/g' $DOC_DIR/*.adoc
sed -i.bak -e 's/\*\([a-z]*\)\(([0-9])\)\*/link:..\/\1[\*\1\2\*]/g' $DOC_DIR/*.adoc
#sed -i.bak -e 's/link:(.*?)\{outfilesuffix\}/link:(.*?)/g' $DOC_DIR/*.adoc
#sed -i.bak -e 's/link:\([a-z]*\){outfilesuffix}/link:..\/\1/g' $DOC_DIR/*.adoc
#sed -i.bak -e 's/link:\([a-z]*_[a-z]*\){outfilesuffix}/link:..\/\1/g' $DOC_DIR/*.adoc
sed -i.bak -e 's/link:\([a-z]*[0-9]*_*[a-z]*[0-9]*_*[a-z]*[0-9]*_*[a-z]*[0-9]*\){outfilesuffix}/link:..\/\1/g' $DOC_DIR/*.adoc
sed -i.bak -e 's/link:..\//link:/g' $DOC_DIR/index.adoc
#sed -i.bak -e 's/{outfilesuffix}//g' $DOC_DIR/*.adoc
sed -i.bak -e "s/toc2\:/${TOC}/g" $DOC_DIR/*.adoc
#sed -i.bak -e '1i\some string\n' $DOC_DIR/acl.adoc
sed -i.bak -e 's/\:numbered\://g' $DOC_DIR/change_history.adoc

#add menu_weights
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

#add last updated date
sed -i.bak -e "/\= Transfer API Documentation/a\\
:revdate: $DATE\\
\\
[doc-info]*Last Updated: {revdate}*
" $DOC_DIR/index.adoc

rm $DOC_DIR/*.adoc.bak
