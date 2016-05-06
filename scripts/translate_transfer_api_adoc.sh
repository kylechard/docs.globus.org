#!/bin/bash


if [ $# -ne 1 ]; then
    echo "Usage: $0 path/to/content/api/transfer"
    exit 1
fi

sed --version 2>&1 | grep -q GNU
if [ $? -eq 0 ]; then
    # GNU sed
    SED_OPTS="-i -e"
else
    # OS X / BSD sed
    SED_OPTS="-i '' -e"
fi

# NB: set after sed check
set -e

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

echo "Performing seds inline on files..."
sed $SED_OPTS 's/----\n/----terminal/g' $DOC_DIR/*.adoc
sed $SED_OPTS 's/\*\([a-z]*\)\(([0-9])\)\*/link:..\/\1[\*\1\2\*]/g' $DOC_DIR/*.adoc
#sed $SED_OPTS 's/link:(.*?)\{outfilesuffix\}/link:(.*?)/g' $DOC_DIR/*.adoc
#sed $SED_OPTS 's/link:\([a-z]*\){outfilesuffix}/link:..\/\1/g' $DOC_DIR/*.adoc
#sed $SED_OPTS 's/link:\([a-z]*_[a-z]*\){outfilesuffix}/link:..\/\1/g' $DOC_DIR/*.adoc
sed $SED_OPTS 's/link:\([a-z]*[0-9]*_*[a-z]*[0-9]*_*[a-z]*[0-9]*_*[a-z]*[0-9]*\){outfilesuffix}/link:..\/\1/g' $DOC_DIR/*.adoc
sed $SED_OPTS 's/link:..\//link:/g' $DOC_DIR/index.adoc
#sed $SED_OPTS 's/{outfilesuffix}//g' $DOC_DIR/*.adoc
sed $SED_OPTS "s/toc2\:/${TOC}/g" $DOC_DIR/*.adoc
#sed $SED_OPTS '1i\some string\n' $DOC_DIR/acl.adoc
sed $SED_OPTS 's/\:numbered\://g' $DOC_DIR/change_history.adoc

#add menu_weights
sed $SED_OPTS "s/^\= /${ACL}" $DOC_DIR/acl.adoc
sed $SED_OPTS "s/^\= /${AEM}" $DOC_DIR/advanced_endpoint_management.adoc
sed $SED_OPTS "s/^\= /${CH}" $DOC_DIR/change_history.adoc
sed $SED_OPTS "s/^\= /${EA}" $DOC_DIR/endpoint_activation.adoc
sed $SED_OPTS "s/^\= /${EB}" $DOC_DIR/endpoint_bookmarks.adoc
sed $SED_OPTS "s/^\= /${ER}" $DOC_DIR/endpoint_roles.adoc
sed $SED_OPTS "s/^\= /${ES}" $DOC_DIR/endpoint_search.adoc
sed $SED_OPTS "s/^\= /${EM}" $DOC_DIR/endpoint.adoc
sed $SED_OPTS "s/^\= /${FO}" $DOC_DIR/file_operations.adoc
sed $SED_OPTS "s/^\= /${O}" $DOC_DIR/overview.adoc
sed $SED_OPTS "s/^\= /${TS}" $DOC_DIR/task_submit.adoc
sed $SED_OPTS "s/^\= /${TASK}" $DOC_DIR/task.adoc
